//
//  MainViewController.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/03/27.
//

import UIKit
import SceneKit
import ModelIO
import RealmSwift

class MainViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var questionTableView: UITableView!
  @IBOutlet weak var scnView: SCNView!
  @IBOutlet weak var questiontableView: UITableView!
  var scnScene: SCNScene!
  var scnNode: SCNNode!
  var cameraNode: SCNNode!
  var domain: String = ""
  var transparency: CGFloat = 1.0 {
    didSet {
      setupTransparency(alpha: transparency)
    }
  }
  
  var datasource: [Question] = [
    Question(questionTitle: "Q. How long have you had this product?", value: 1), // 0
    Question(questionTitle: "Color", color: UIColor.red), // sphere 1
    Question(questionTitle: "1-5. How important was the color in the selection of the product?", value: 1), // 높이 2
    Question(questionTitle: "1-6. On a scale of 1 to 10, was the color selection based on function or emotion?", value: 1), // 크기 3
    Question(questionTitle: "Material", material: "leather"), // cube 4
    Question(questionTitle: "2-5. How important was the material+finish in the selection of the product?", value: 1), // 5
    Question(questionTitle: "2-6. On a scale of 1 to 10, was the material+finish selection based on function or emotion?", value: 1), // 6
    Question(questionTitle: "Finish ", finish: Finish.Brushed), // cylinder 7
    Question(questionTitle: "3-5. How important was the material+finish in the selection of the product?", value: 1), // 8
    Question(questionTitle: "3-6. On a scale of 1 to 10, was the material+finish selection based on function or emotion?", value: 1) //9
  ]
  var presentColorViewController: (() -> Void)?
  var updateColor: ((UIColor) -> Void)?
  var handler: ((UIColor) -> Void)?
  var lastPanLocation = SCNVector3(x: 1, y: 1, z: 0)
  var spherePoint: SCNVector3?
  var cubePoint: SCNVector3?
  var cylinderPoint: SCNVector3?
  var mainSpherePosition: SCNVector3 = SCNVector3(x: 4, y: 1, z: 3)
  var mainCubePosition = SCNVector3(x: 1, y: 1, z: 0)
  var mainCylinderPosition = SCNVector3(x: 7, y: 1, z: 0)
  var panStartz: CGFloat = 0
  var targetNode: SCNNode?
  
  var cubeInfo = CubeInfo(image: UIImage(), size: (width: 1, height: 1, length: 1))
  var sphereInfo = SphereInfo()
  var cylinderInfo = CylinderInfo(image: UIImage())
  var totalModel: TotalModel?
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupView()
    setupScene()
    setupCamera()
    spawnShape()
    transparency = 1 / 6
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getObject()
  }

  func setupView() {
    // 1
    scnView.showsStatistics = true
    // 2
    scnView.allowsCameraControl = true
    // 3
    scnView.autoenablesDefaultLighting = true
    // 4
    scnView.backgroundColor = UIColor(hex: "f9fbfb")
  }
  
  func setupScene() {
    scnScene = SCNScene()
    scnView.scene = scnScene
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 4, y: 7, z: 8)
    cameraNode.eulerAngles = SCNVector3(-0.7, 0, 0)
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func spawnShape() {
    //    let path = Bundle.main.path(forResource: "test", ofType: "obj")
    //    let url = URL(fileURLWithPath: path!)
    //    let asset = MDLAsset(url: url)
    
    //    guard let object = asset.object(at: 0) as? MDLMesh else {return}
    //    let node = SCNNode(mdlObject: object)
    let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
    let boxNode = SCNNode(geometry: box)
//    boxNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: datasource[3].material ?? "glossy")
    boxNode.position = SCNVector3(1,1,0)
    cubePoint = boxNode.position
    boxNode.name = "cube"
    scnScene.rootNode.addChildNode(boxNode)
    
    let sphere = SCNSphere(radius: 0.5)
    sphere.firstMaterial?.diffuse.contents = UIColor.red
    let node = SCNNode(geometry: sphere)
    node.name = "sphere"
    node.position = SCNVector3(boxNode.position.x + 3, boxNode.position.y, boxNode.position.z + 3)
    spherePoint = node.position
    scnScene.rootNode.addChildNode(node)
    
    
    let cylinder = SCNCylinder(radius: 0.5, height: 1)
    cylinder.firstMaterial?.diffuse.contents = UIImage(named: datasource[6].material ?? "glossy")
    let cylinderNode = SCNNode(geometry: cylinder)
    cylinderNode.name = "cylinder"
    cylinderNode.position = SCNVector3(boxNode.position.x + 6, boxNode.position.y, boxNode.position.z)
    cylinderPoint = cylinderNode.position
    scnScene.rootNode.addChildNode(cylinderNode)
    
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  // MARK: - UI
  
  private func setupUI() {
    questionTableView.register(UINib(nibName: QuestionTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: QuestionTableViewCell.identifier)
    questionTableView.register(UINib(nibName: TextureTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TextureTableViewCell.identifier)
    questiontableView.delegate = self
    questiontableView.dataSource = self
    
    presentColorViewController = { [weak self] in
      guard let self = self else {return}
      let colorViewController = UIColorPickerViewController()
      colorViewController.delegate = self
      self.present(colorViewController, animated: true, completion: nil)
    }
  }
  
  
  // MARK: - IBAction
  
  @IBAction func didTapShareButton(_ sender: Any) {
    
    let cube = scnScene.rootNode.childNode(withName: "cube", recursively: true)!.geometry!
    let sphere = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!.geometry!
    let cylinder = scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!.geometry!
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timestamp = dateFormatterGet.string(from: Date())

    let fixedFilenameOBJ = timestamp + ".obj"

    let fullPathOBJ = getDocumentsDirectory().appendingPathComponent(fixedFilenameOBJ) // for the OBJ file

    let cubeMesh = MDLMesh(scnGeometry: cube)
    let sphereMesh = MDLMesh(scnGeometry: sphere)
    let cylinderMesh = MDLMesh(scnGeometry: cylinder)
    let asset = MDLAsset()
    asset.add(cubeMesh)
    asset.add(sphereMesh)
    asset.add(cylinderMesh)
    
    do {
//      let my3d = try asset.export(to: fullPathOBJ)
      let realm = try Realm()
      
      totalModel = TotalModel(domain: domain,
                                  importanceForColor: datasource[1].value ?? 1,
                                  FunctionalAndEmotionalForColor: datasource[2].value ?? 1,
                                  importanceForMaterial: datasource[4].value ?? 1,
                                  FunctionalAndEmotionalForMaterial: datasource[5].value ?? 1
      )

      guard let totalModel = totalModel else {
        return
      }
      
      
      try! realm.write({
        realm.add(ObjectModel(totalModel: totalModel, cube: cubeInfo, sphere: sphereInfo, cylinder: cylinderInfo))
      })

    } catch {
      print("Couldn't create file(s)")
      return
    }
    
  }
  
  @IBAction func gotoResultVC(_ sender: UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(identifier: "GameViewController") as! GameViewController
    vc.cubeInfo = cubeInfo
    vc.cylinderInfo = cylinderInfo
    vc.sphereInfo = sphereInfo
    vc.totalModel = totalModel
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    datasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as? QuestionTableViewCell else {return QuestionTableViewCell()}
    
    cell.questionLabel.text = datasource[indexPath.row].questionTitle
    cell.index = indexPath.row
    cell.questionValueLabel.text = "\(self.datasource[indexPath.row].value ?? 0)"
    cell.questionSlider.value = Float(self.datasource[indexPath.row].value ?? 0)
    
    if indexPath.row == 0 {
      cell.textFieldsStackView.isHidden = true
      cell.questionValueLabel.isHidden = false
      cell.colorField.isHidden = true
      cell.questionSlider.isHidden = false
      cell.questionSlider.minimumValue = 1
      cell.questionSlider.maximumValue = Float(HowLong.allCases.count)
      cell.questionValueLabel.text = HowLong.allCases[0].description
      cell.stackview.isHidden = true
      
      cell.updateValue = { [weak self] index, value in
        guard let self = self, self.datasource[index].value != value else {return}
        self.datasource[index].value = value
        cell.questionValueLabel.text = HowLong.allCases[(self.datasource[0].value ?? 1) - 1].description
        self.transparency = CGFloat(value)
      }
    } else if indexPath.row % 3 == 1 { //indexpath == 1, 4, 7
      cell.questionValueLabel.isHidden = true
      cell.questionSlider.isHidden = true
      cell.stackview.isHidden = true
      // MARK: -  COLOR
      if indexPath.row == 1 {
        cell.textFieldsStackView.isHidden = true
        cell.colorField.isHidden = false
        cell.updateColor =  { [weak self] color in
          guard let self = self else {return}
          self.move(focusName: "sphere") { self.move(focusName: $0, completion: {_ in })}
          cell.colorField.backgroundColor = color
          self.sphereInfo.color = color
          self.datasource[indexPath.row].color = color
        }
        handler = cell.updateColor
        cell.colorViewController = UIColorPickerViewController()
        cell.presentColorPicker = { [weak self] in
          guard let self = self else {return}
          cell.colorViewController!.delegate = self
          cell.colorViewController?.supportsAlpha = false
          self.present(cell.colorViewController!, animated: true, completion: nil)
        }
        // MARK: - Material indexpath 4, 7
      } else {
        
        cell.textFieldsStackView.isHidden = false
        cell.colorField.isHidden = true
        cell.questionTextfield.placeholder = "Enter the Material"
        cell.finishTextField.placeholder = "Enter the Finish"
        
        if indexPath.row == 4 {
          cell.finishTextField.isHidden = true
          cell.updateUI = { [weak self] (value, finish) in
            guard let self = self else {return}
            self.datasource[indexPath.row].material = value
            self.datasource[indexPath.row].finish = finish
            self.move(focusName: "cube") { self.move(focusName: $0, completion: { _ in}) }
            let cube = self.scnScene.rootNode.childNode(withName: "cube", recursively: true)!
            let material = self.datasource[indexPath.row].material ?? "Wood"
            //            let finish = self.datasource[indexPath.row].finish ?? .Natural
            
            // MARK: - 이미지형식: Wood + Natural -> WoodNatural.png
            guard let image = UIImage(named: material) else {return}
            self.cubeInfo.image = image
            cube.geometry?.firstMaterial?.diffuse.contents = image
          }
        } else {
          cell.questionTextfield.isHidden = true
          cell.updateUI = { [weak self] (value, finish) in
            guard let self = self else {return}
            self.datasource[indexPath.row].material = value
            self.datasource[indexPath.row].finish = finish
            self.move(focusName: "cylinder") { self.move(focusName: $0, completion: { _ in}) }
            let cylinder = self.scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
            let finish = self.datasource[indexPath.row].finish ?? .Natural
            
            // MARK: - 이미지형식: Wood + Natural -> WoodNatural.png
            guard let image = UIImage(named: finish.rawValue) else {return}
            self.cylinderInfo.image = image
            cylinder.geometry?.firstMaterial?.diffuse.contents = image
          }
        }
      }
      // MARK: - Questions
    } else {
      cell.textFieldsStackView.isHidden = true
      cell.questionValueLabel.isHidden = false
      cell.colorField.isHidden = true
      cell.questionSlider.isHidden = false
      if indexPath.row % 3 == 0 {
        
        cell.questionSlider.minimumValue = 1
        cell.questionSlider.maximumValue = 5
        cell.stackview.isHidden = false
      } else {
        // 1-5, 2-5
        cell.questionSlider.minimumValue = 1
        cell.questionSlider.maximumValue = 5
        cell.stackview.isHidden = true
      }
      
      // MARK: - Update value -> Animation
      cell.updateValue = { [weak self] (index, value)in
        guard let self = self, self.datasource[index].value != value else {return}
        self.datasource[index].value = value
        if indexPath.row == 2 || indexPath.row == 3 {
          self.move(focusName: "sphere") { self.move(focusName: $0)}
          self.sphereScaleUp(radius: CGFloat(self.datasource[3].value ?? 1),
                             height: CGFloat(self.datasource[2].value ?? 1))
         
        } else if indexPath.row == 5 || indexPath.row == 6 {
          self.move(focusName: "cube") { self.move(focusName: $0)}
          self.heightScaleUp(height: CGFloat(self.datasource[5].value ?? 1),
                             width: CGFloat(self.datasource[6].value ?? 1),
                             length: CGFloat(self.datasource[6].value ?? 1))
        } else {
          self.move(focusName: "cylinder") { self.move(focusName: $0)}
          self.cylinderScaleUp(height: CGFloat(self.datasource[8].value ?? 1),
                               radius: CGFloat(self.datasource[9].value ?? 1))
        }
      }
    }
    
    return cell
  }
  
}

// MARK: - 3D Action Control
extension MainViewController {

  func move(focusName: String, completion: ((String) -> ())? = nil) {
    let focusNode = scnScene.rootNode.childNode(withName: focusName, recursively: true)!
    guard focusNode.position.x != mainSpherePosition.x else {return}
    if focusNode.position.x < mainSpherePosition.x {
      move120(direction: .clockwise)
      completion?(focusName)
    } else if focusNode.position.x > mainSpherePosition.x {
      move120(direction: .unclockwise)
      completion?(focusName)
    }
  }
  
  func move120(direction: Direction) {
    let cube = scnScene.rootNode.childNode(withName: "cube", recursively: true)!
    let cylinder = scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
    let sphere = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!
    guard let spherePoint = spherePoint, let cubePoint = cubePoint, let cylinderPoint = cylinderPoint else {
      return
    }
    let gotoSphere = SCNAction.move(to: spherePoint, duration: 0.5)
    let gotoCube = SCNAction.move(to: cubePoint, duration: 0.5)
    let gotoCylinder = SCNAction.move(to: cylinderPoint, duration: 0.5)
    switch direction {
    case .clockwise:
      sphere.runAction(gotoCylinder) { [weak self] in
        self?.spherePoint = sphere.position
      }
      cylinder.runAction(gotoCube) { [weak self] in
        self?.cylinderPoint = cylinder.position
      }
      cube.runAction(gotoSphere) { [weak self] in
        self?.cubePoint = cube.position
      }
    case .unclockwise:
      sphere.runAction(gotoCube) { [weak self] in
        self?.spherePoint = sphere.position
      }
      cylinder.runAction(gotoSphere) { [weak self] in
        self?.cylinderPoint = cylinder.position
      }
      cube.runAction(gotoCylinder) { [weak self] in
        self?.cubePoint = cube.position
      }
    }
  }
  
  func heightScaleUp(height: CGFloat, width: CGFloat, length: CGFloat) {
    let cube = scnScene.rootNode.childNode(withName: "cube", recursively: true)!
    let action2 = SCNAction.customAction(duration: 1) { node, num in
      let percentage = num / CGFloat(1)
      guard let box = node.geometry as? SCNBox else {return}
      let oldHeight = box.height
      let oldWidth = box.width
      let oldLength = box.length
      let newHeight = oldHeight + (height - oldHeight) * percentage
      let newWidth = oldWidth + (width - oldWidth) * percentage
      let newLength = oldLength + (length - oldLength) * percentage
      box.length = newLength
      box.width = newWidth
      box.height = newHeight
    }
    self.cubeInfo.size = (width, height, length)
    cube.runAction(action2)
  }
  
  func cylinderScaleUp(height: CGFloat, radius: CGFloat) {
    let cylinder = scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
    let action = SCNAction.customAction(duration: 1) { node, num in
      let percentage = num / CGFloat(1)
      guard let cylinder = node.geometry as? SCNCylinder else {return}
      let oldRadius = cylinder.radius
      let oldHeight = cylinder.height
      let newHeight = oldHeight + (height - oldHeight) * percentage
      let newRadius = oldRadius + (radius / 2 - oldRadius) * percentage
      cylinder.height = newHeight
      cylinder.radius = newRadius
    }
    self.cylinderInfo.size = (radius / 2, height)
    cylinder.runAction(action)
  }
  
  func sphereScaleUp(radius: CGFloat, height: CGFloat) {
    let sphere = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!
    let action = SCNAction.customAction(duration: 1) { node, num in
      
      let percentage = num / CGFloat(1)
      guard let sphere = node.geometry as? SCNSphere else {return}
      let oldX = node.scale.x
      let oldY = node.scale.y
      let oldZ = node.scale.z
      
      node.scale.x = Float(oldX + (Float(radius)  - oldX) * Float(percentage))
      node.scale.y = Float(oldY + Float((height  - CGFloat(oldY)) * CGFloat(Float(percentage))))
      node.scale.z = Float(oldZ + (Float(radius) - oldZ) * Float(percentage))
      
    }
    self.sphereInfo.radius = radius
    self.sphereInfo.height = height
    sphere.runAction(action)
  }
  
  func setupTransparency(alpha: CGFloat) {
    let sphere = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!
    let cylinder = scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
    let cube = scnScene.rootNode.childNode(withName: "cube", recursively: true)!
    let nodes = [sphere, cylinder, cube]
    nodes.forEach { node in
      node.geometry?.firstMaterial?.transparency = 1 / (7 - alpha)
    }
    cubeInfo.transparency = 1 / (7 - alpha)
    sphereInfo.transparency = 1 / (7 - alpha)
    cylinderInfo.transparency = 1 / (7 - alpha)
  }
  
}

extension MainViewController: UITableViewDelegate {
  
}

extension MainViewController: UIColorPickerViewControllerDelegate {
  func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
    handler?(color)
    let test = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!
    test.geometry?.materials.first?.diffuse.contents = color
  }
}

// MARK: - Private
extension MainViewController {
  func getObject() {
    do {
      let realm = try Realm()
      let result = Array(realm.objects(ObjectModel.self))
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension MainViewController {
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0] // paths[0]
  }
}

