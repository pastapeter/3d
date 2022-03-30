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
  @IBOutlet weak var importanceLabel: UILabel!
  @IBOutlet weak var FunctionalLabel: UILabel!
  
  
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
    
  }
  
  func setupScene() {
    scnScene = SCNScene()
    sceneView.scene = scnScene
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 7, z: 8)
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
  }
  
  
}
