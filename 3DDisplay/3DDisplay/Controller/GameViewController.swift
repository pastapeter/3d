import UIKit
import SceneKit
import SceneKit.ModelIO
import RealmSwift

class GameViewController: UIViewController {
  
  var scnView: SCNView!
  var scnScene: SCNScene!
  var cameraNode: SCNNode!
  var currentAngle: Float = 0.0
  var panStartz: CGFloat = 0
  var targetNode: SCNNode?
  var lastPanLocation = SCNVector3(x: 1, y: 1, z: 0)
  
  var cubeInfo: CubeInfo?
  var sphereInfo: SphereInfo?
  var cylinderInfo: CylinderInfo?
  var totalModel: TotalModel?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupScene()
    setupCamera()
    spawnShape()
  }
  
  func setupView() {
    scnView = self.view as! SCNView
    // 1
    scnView.showsStatistics = true
    // 2
    scnView.allowsCameraControl = true
    // 3
    scnView.autoenablesDefaultLighting = true
    
    scnView.backgroundColor = UIColor(hex: "f9fbfb")
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:)))
    scnView.addGestureRecognizer(panRecognizer)
    
  }
  
  func setupScene() {
    scnScene = SCNScene()
    scnView.scene = scnScene
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 4, y: 12, z: 15)
    cameraNode.eulerAngles = SCNVector3(x: -0.7, y: 0, z: 0)
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func spawnShape() {
    guard let sphereInfo = sphereInfo, let cubeInfo = cubeInfo, let cylinderInfo = cylinderInfo else {
      return
    }
    let box = SCNBox(width: cubeInfo.size.width, height: cubeInfo.size.height, length: cubeInfo.size.length, chamferRadius: 0)
    box.firstMaterial?.transparency = cubeInfo.transparency
    let boxNode = SCNNode(geometry: box)
    boxNode.geometry?.firstMaterial?.diffuse.contents = cubeInfo.image
    boxNode.position = cubeInfo.position
    boxNode.name = cubeInfo.name
    scnScene.rootNode.addChildNode(boxNode)
    
    let sphere = SCNSphere(radius: 1.0)
    sphere.firstMaterial?.diffuse.contents = sphereInfo.color
    sphere.firstMaterial?.transparency = sphereInfo.transparency
    let node = SCNNode(geometry: sphere)
    node.scale.x = Float(sphereInfo.radius)
    node.scale.y = Float(sphereInfo.height)
    node.scale.z = Float(sphereInfo.radius)
    node.name = sphereInfo.name
    node.position = sphereInfo.position
    scnScene.rootNode.addChildNode(node)
    
    let cylinder = SCNCylinder(radius: cylinderInfo.size.radius, height: cylinderInfo.size.height)
    cylinder.firstMaterial?.diffuse.contents = cylinderInfo.image
    cylinder.firstMaterial?.transparency = cylinderInfo.transparency
    let cylinderNode = SCNNode(geometry: cylinder)
    cylinderNode.name = cylinderInfo.name
    cylinderNode.position = cylinderInfo.position
    scnScene.rootNode.addChildNode(cylinderNode)
  }
  
  override var shouldAutorotate: Bool {
    return true
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
    
//    guard let geometry = scnScene.rootNode.childNode(withName: "test", recursively: true)?.geometry else {return }
//
//    let fixedFilenameOBJ = String("MyGeometryObject.obj")
//    let fixedFilenameMTL = String("MyGeometryObject.mtl")
//
//    let fullPathOBJ = getDocumentsDirectory().appendingPathComponent(fixedFilenameOBJ) // for the OBJ file
//    let fullPathMTL = getDocumentsDirectory().appendingPathComponent(fixedFilenameMTL) // for the MTL file
//
//    let mesh = MDLMesh(scnGeometry: geometry)
//    let asset = MDLAsset()
//    asset.add(mesh)
    
    do {
      let realm = try Realm()
      guard let totalModel = totalModel else { return }
    
      
    } catch {
      print("Couldn't create file(s)")
      return
    }
    
  }
  
}

extension GameViewController {
  
  func getDocumentsDirectory() -> URL {
    let paths = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return paths // paths[0]
  }
  
  @objc func handlePan(panGesture: UIPanGestureRecognizer) {
    let location = panGesture.location(in: scnView)
    switch panGesture.state {
    case .began:
      guard let hitNodeResult = scnView.hitTest(location, options: nil).first else {return}
      panStartz = CGFloat(scnView.projectPoint(lastPanLocation).z)
      lastPanLocation = hitNodeResult.worldCoordinates
      if hitNodeResult.node.name == "sphere" {
        targetNode = scnScene.rootNode.childNode(withName: "sphere", recursively: true)!
      } else if hitNodeResult.node.name == "cube" {
        targetNode = scnScene.rootNode.childNode(withName: "cube", recursively: true)!
      } else if hitNodeResult.node.name == "cylinder" {
        targetNode = scnScene.rootNode.childNode(withName: "cylinder", recursively: true)!
      } else {
        targetNode = nil
      }
    case .changed:
      let location = panGesture.location(in: scnView)
      let worldTouchPosition = scnView.unprojectPoint(SCNVector3(location.x, location.y, panStartz))
      let dragX = worldTouchPosition.x - lastPanLocation.x
      let movementVector = SCNVector3(dragX, worldTouchPosition.y - lastPanLocation.y, worldTouchPosition.z - lastPanLocation.z)
      guard let targetNode = targetNode else {
        return
      }
      targetNode.localTranslate(by: movementVector)
      self.lastPanLocation = worldTouchPosition
    case .ended:
      targetNode = nil
    default:
      break
    }
    
  }
}
