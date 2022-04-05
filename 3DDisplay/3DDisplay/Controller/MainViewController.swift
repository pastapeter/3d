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
    Question(questionTitle: "Color", color: UIColor.red), // 원형 or 실린더
    Question(questionTitle: "1-5. How important was the color in the selection of the product?", value: 1), // 높이
    Question(questionTitle: "1-6. On a scale of 1 to 10, was the color selection based on function or emotion?", value: 1), // 크기
    Question(questionTitle: "Material", material: "leather"), // 큐브
    Question(questionTitle: "2-5. How important was the material+finish in the selection of the product?", value: 1),
    Question(questionTitle: "2-6. On a scale of 1 to 10, was the material+finish selection based on function or emotion?", value: 1)
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
    let test = scnScene.rootNode.childNode(withName: "test", recursively: true)!
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
    test.runAction(action2)
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
    cameraNode.position = SCNVector3(x: 2.5, y: 7, z: 8)
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
    let node = SCNNode(geometry: box)
    node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
    node.scale = SCNVector3(1, 1, 1)
    node.name = "test"
    scnScene.rootNode.addChildNode(node)
    
    let cylinder = SCNCylinder(radius: 1, height: 1)
    cylinder.firstMaterial?.diffuse.contents = UIImage(named: datasource[3].material ?? "plastic")
    let cylinderNode = SCNNode(geometry: cylinder)
    cylinderNode.name = "cylinder"
    cylinderNode.position = SCNVector3(node.position.x + 5, node.position.y, node.position.z)
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
    
    if indexPath.row % 3 == 0 {
      cell.questionValueLabel.isHidden = true
      cell.questionSlider.isHidden = true
      cell.stackview.isHidden = true
      // MARK: -  COLOR
      if indexPath.row == 0 {
        cell.questionTextfield.isHidden = true
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
        // MARK: - Material
      } else {
        
        cell.questionTextfield.isHidden = false
        cell.colorField.isHidden = true
        cell.questionTextfield.placeholder = "Enter the Material"
        
        cell.updateUI = { [weak self] (value) in
          guard let self = self else {return}
          self.datasource[indexPath.row].material = value
          let cylinder = self.scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
          cylinder.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.datasource[indexPath.row].material ?? "plastic")
        }
      }
      // MARK: - Questions
    } else {
      cell.questionTextfield.isHidden = true
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
          self.heightScaleUp(height: CGFloat(self.datasource[1].value ?? 1), width: CGFloat(self.datasource[2].value ?? 1), length: CGFloat(self.datasource[2].value ?? 1))
        } else if indexPath.row == 4 || indexPath.row == 5 {
          self.cylinderScaleUp(height: CGFloat(self.datasource[4].value ?? 1), radius: CGFloat(self.datasource[5].value ?? 1))
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
    let test = scnScene.rootNode.childNode(withName: "test", recursively: true)!
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

