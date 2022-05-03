//
//  AlbumCollectionViewCell.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/03/29.
//

import UIKit
import SceneKit
import ModelIO

class AlbumCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "AlbumCollectionViewCell"
  static let nibName = "AlbumCollectionViewCell"
  
  var scnScene: SCNScene!
  var scnNode: SCNNode!
  var cameraNode: SCNNode!
  
  @IBOutlet weak var sceneView: SCNView!
  @IBOutlet weak var domainLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var colorHexLabel: UILabel!
  @IBOutlet weak var materialLabel: UILabel!
  @IBOutlet weak var finishLabel: UILabel!
  
  @IBOutlet weak var firstStackview: UIStackView!
  @IBOutlet weak var secondStackView: UIStackView!
  @IBOutlet weak var thirdStackView: UIStackView!
  @IBOutlet weak var forthStackView: UIStackView!
  
  @IBOutlet var importanceLabels: [UILabel]!
  @IBOutlet var funcEmoLabels: [UILabel]!
  
  var importanceArray: [String] = [] {
    didSet {
      for i in importanceArray.indices {
        importanceLabels[i].text = importanceArray[i]
      }
    }
  }
  
  var funcEmoArray: [String] = [] {
    didSet {
      for i in funcEmoArray.indices {
        funcEmoLabels[i].text = funcEmoArray[i]
      }
    }
  }

  var transparency: CGFloat = 1.0
  var cylinderSize: (Float, Float) = (0.0, 0.0)
  var cylinderImage: Data?
  var sphereSize: (Float, Float) = (0.0, 0.0) // (radius, height)
  var sphereColor: UIColor = .red
  
//  var boxSize
  var sphere: SCNSphere?
  var node: SCNNode?
  var cylinder: SCNCylinder?
  var cylinderNode: SCNNode?
  var box: SCNBox?
  var boxNode: SCNNode?
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
    setupScene()
    setupCamera()
    spawnShape()
  }
  
  
  func setupView() {
    // 1
    sceneView.showsStatistics = true
    // 2
    sceneView.allowsCameraControl = true
    // 3
    sceneView.autoenablesDefaultLighting = true
    
//    sceneView.backgroundColor = UIColor(hex: "f9fbfb")
//    sceneView.scene?.background.contents = backgroundImage
  }
  
  func setupScene() {
    scnScene = SCNScene()
    sceneView.scene = scnScene
    scnScene.background.contents = backgroundImage
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 4, y: 7, z: 8)
    cameraNode.eulerAngles = SCNVector3(-0.7, 0, 0)
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func spawnShape() {
    
    box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
    boxNode = SCNNode(geometry: box)
    guard let boxNode = boxNode else {
      return
    }
    boxNode.geometry?.firstMaterial?.diffuse.contents = UIImage()
    boxNode.position = SCNVector3(1,1,0)
    boxNode.name = "cube"
    boxNode.geometry?.firstMaterial?.transparency = transparency
    scnScene.rootNode.addChildNode(boxNode)
    
    sphere = SCNSphere(radius: 0.5)
    node = SCNNode(geometry: sphere)
    guard let node = node else {
      return
    }
    node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
    node.name = "sphere"
    node.geometry?.firstMaterial?.transparency = transparency
    node.geometry?.firstMaterial?.diffuse.contents = sphereColor
    node.position = SCNVector3(boxNode.position.x + 3, boxNode.position.y, boxNode.position.z + 3)
    scnScene.rootNode.addChildNode(node)
    
    cylinder = SCNCylinder(radius: 0.5, height: 1)
    cylinderNode = SCNNode(geometry: cylinder)
    guard let cylinderNode = cylinderNode else {
      return
    }
    cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Glossy")
    cylinderNode.name = "cylinder"
    cylinderNode.geometry?.firstMaterial?.transparency = transparency
    cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIImage(data: cylinderImage ?? Data())
    cylinderNode.position = SCNVector3(boxNode.position.x + 6, boxNode.position.y, boxNode.position.z)
    scnScene.rootNode.addChildNode(cylinderNode)
    
  }
  
}

