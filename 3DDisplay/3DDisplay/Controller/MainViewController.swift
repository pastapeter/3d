//
//  MainViewController.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/03/27.
//

import UIKit
import SceneKit
import ModelIO

struct Question {
  var questionTitle: String
  var value: Int?
  var color: UIColor?
  var material: String?
  var finish: Finish?
}

class MainViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var questionTableView: UITableView!
  @IBOutlet weak var scnView: SCNView!
  @IBOutlet weak var questiontableView: UITableView!
  var scnScene: SCNScene!
  var scnNode: SCNNode!
  var cameraNode: SCNNode!
  var domain: String = ""
  
  var datasource: [Question] = [
    Question(questionTitle: "Color", color: UIColor.red), // sphere
    Question(questionTitle: "1-5. How important was the color in the selection of the product?", value: 1), // 높이
    Question(questionTitle: "1-6. On a scale of 1 to 10, was the color selection based on function or emotion?", value: 1), // 크기
    Question(questionTitle: "Material / Finish", material: "leather", finish: Finish.Brushed), // cube
    Question(questionTitle: "2-5. How important was the material+finish in the selection of the product?", value: 1),
    Question(questionTitle: "2-6. On a scale of 1 to 10, was the material+finish selection based on function or emotion?", value: 1),
    Question(questionTitle: "Material / Finish ", material: "leather", finish: Finish.Brushed), // cylinder
    Question(questionTitle: "3-5. How important was the material+finish in the selection of the product?", value: 1),
    Question(questionTitle: "3-6. On a scale of 1 to 10, was the material+finish selection based on function or emotion?", value: 1)
  ]
  var presentColorViewController: (() -> Void)?
  var updateColor: ((UIColor) -> Void)?
  var handler: ((UIColor) -> Void)?
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupView()
    setupScene()
    setupCamera()
    spawnShape()
  }
  
  // MARK: - 3D Control
  // 1 -> 5 로가는데,
  
  
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
      
      node.scale.x = Float(oldX + (Float(radius) / 2 - oldX) * Float(percentage))
      node.scale.y = Float(oldY + Float((height / 2 - CGFloat(oldY)) * CGFloat(Float(percentage))))
      node.scale.z = Float(oldZ + (Float(radius) / 2 - oldZ) * Float(percentage))
    
    }
    sphere.runAction(action)
  }

  
  func setupView() {
    // 1
    scnView.showsStatistics = true
    // 2
    scnView.allowsCameraControl = true
    // 3
    scnView.autoenablesDefaultLighting = true
    
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
    let sphere = SCNSphere(radius: 0.5)
    sphere.firstMaterial?.diffuse.contents = UIColor.red
    let node = SCNNode(geometry: sphere)
    node.name = "sphere"
    node.position = SCNVector3(1,1,1)
    scnScene.rootNode.addChildNode(node)
    
    let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
    let boxNode = SCNNode(geometry: box)
    boxNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: datasource[3].material ?? "plastic")
    boxNode.position = SCNVector3(node.position.x + 3, node.position.y, node.position.z)
    boxNode.name = "cube"
    scnScene.rootNode.addChildNode(boxNode)
    
    let cylinder = SCNCylinder(radius: 0.5, height: 1)
    cylinder.firstMaterial?.diffuse.contents = UIImage(named: datasource[6].material ?? "plastic")
    let cylinderNode = SCNNode(geometry: cylinder)
    cylinderNode.name = "cylinder"
    cylinderNode.position = SCNVector3(node.position.x + 6, node.position.y, node.position.z)
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
    guard let geometry = scnScene.rootNode.childNode(withName: "test", recursively: true)?.geometry else {return }
    
    let fixedFilenameOBJ = String("MyGeometryObject.obj")
    let fixedFilenameMTL = String("MyGeometryObject.mtl")
    
    let fullPathOBJ = getDocumentsDirectory().appendingPathComponent(fixedFilenameOBJ) // for the OBJ file
    let fullPathMTL = getDocumentsDirectory().appendingPathComponent(fixedFilenameMTL) // for the MTL file
    
    let mesh = MDLMesh(scnGeometry: geometry)
    let asset = MDLAsset()
    asset.add(mesh)
    
    do {
      let my3d = try asset.export(to: fullPathOBJ)
      
      let totalModel = totalModel(domain: domain,
                                  importanceForColor: datasource[1].value ?? 1,
                                  FunctionalAndEmotionalForColor: datasource[2].value ?? 1,
                                  importanceForMaterial: datasource[4].value ?? 1,
                                  FunctionalAndEmotionalForMaterial: datasource[5].value ?? 1,
                                  URL: fullPathOBJ
      )
      
    } catch {
      print("Couldn't create file(s)")
      return
    }
    
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
    
    if indexPath.row % 3 == 0 { //indexpath == 0, 3, 6
      cell.questionValueLabel.isHidden = true
      cell.questionSlider.isHidden = true
      cell.stackview.isHidden = true
      // MARK: -  COLOR
      if indexPath.row == 0 {
        cell.textFieldsStackView.isHidden = true
        cell.colorField.isHidden = false
        cell.updateColor =  { [weak self] color in
          guard let self = self else {return}
          cell.colorField.backgroundColor = color
          self.datasource[indexPath.row].color = color
        }
        handler = cell.updateColor
        cell.colorViewController = UIColorPickerViewController()
        cell.presentColorPicker = { [weak self] in
          guard let self = self else {return}
          cell.colorViewController!.delegate = self
          self.present(cell.colorViewController!, animated: true, completion: nil)
        }
        // MARK: - Material indexpath 3, 6
      } else {
        
        cell.textFieldsStackView.isHidden = false
        cell.colorField.isHidden = true
        cell.questionTextfield.placeholder = "Enter the Material"
        cell.finishTextField.placeholder = "Enter the Finish"
        
        if indexPath.row == 3 {
          cell.updateUI = { [weak self] (value, finish) in
            guard let self = self else {return}
            self.datasource[indexPath.row].material = value
            self.datasource[indexPath.row].finish = finish
            let cube = self.scnScene.rootNode.childNode(withName: "cube", recursively: true)!
            let material = self.datasource[indexPath.row].material ?? "Wood"
            let finish = self.datasource[indexPath.row].finish ?? .Natural
            
            // MARK: - 이미지형식: Wood + Natural -> WoodNatural.png
            print(material+finish.rawValue)
            cube.geometry?.firstMaterial?.diffuse.contents = UIImage(named: material+finish.rawValue)
          }
        } else {
          cell.updateUI = { [weak self] (value, finish) in
            guard let self = self else {return}
            self.datasource[indexPath.row].material = value
            self.datasource[indexPath.row].finish = finish
            let cylinder = self.scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
            let material = self.datasource[indexPath.row].material ?? "Wood"
            let finish = self.datasource[indexPath.row].finish ?? .Natural
            
            // MARK: - 이미지형식: Wood + Natural -> WoodNatural.png
            print(material+finish.rawValue)
            cylinder.geometry?.firstMaterial?.diffuse.contents = UIImage(named: material+finish.rawValue)
          }
        }
      }
      // MARK: - Questions
    } else {
      cell.textFieldsStackView.isHidden = true
      cell.questionValueLabel.isHidden = false
      cell.colorField.isHidden = true
      cell.questionSlider.isHidden = false
      if indexPath.row % 3 == 2 {
        
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
        if indexPath.row == 1 || indexPath.row == 2 {
          self.sphereScaleUp(radius: CGFloat(self.datasource[2].value ?? 1),
                             height: CGFloat(self.datasource[1].value ?? 1))
        } else if indexPath.row == 4 || indexPath.row == 5 {
          self.heightScaleUp(height: CGFloat(self.datasource[4].value ?? 1),
                             width: CGFloat(self.datasource[5].value ?? 1),
                             length: CGFloat(self.datasource[5].value ?? 1))
        } else {
          self.cylinderScaleUp(height: CGFloat(self.datasource[7].value ?? 1),
                               radius: CGFloat(self.datasource[8].value ?? 1))
        }
      }
    }
    
    return cell
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
  private func getDocumentsDirectory() -> URL {
    let paths = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return paths // paths[0]
  }
}

