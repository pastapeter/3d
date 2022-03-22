import UIKit
import SceneKit
import SceneKit.ModelIO

class GameViewController: UIViewController {
  
  var scnView: SCNView!
  var scnScene: SCNScene!
  var cameraNode: SCNNode!
  var alphaList: [CGFloat] = [0.3, 0.8, 1.0]
  var data: [Question] = []
  var currentAngle: Float = 0.0
  var geometryNode: SCNNode = SCNNode()
  var shapeDatasource: [(texture: String, color: UIColor, finish: String)] = [
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: "")
    ]
  
  var shapeIndex: Int = 0

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
    
  }
  
  func setupScene() {
    scnScene = SCNScene()
    scnView.scene = scnScene
//    scnScene.background.contents = UIImage(named: "background")
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func spawnShape() {
    var geometry: [SCNGeometry] = []
    geometry = ShapeType(rawValue: shapeIndex)!.geoMetries
    var geometryNodes: [SCNNode] = []
    switch shapeIndex{
    case 0:
      let box = geometry[0] as! SCNBox
      box.width = CGFloat(1 + (Double(data[0].value) - 1.0) * 0.75)
      box.height = CGFloat(1 + (Double(data[0].value) - 1.0) * 0.75)
      box.length = CGFloat(1 + (Double(data[0].value) - 1.0) * 0.75)
      
      
      box.firstMaterial?.diffuse.contents = shapeDatasource[shapeIndex].color
      box.firstMaterial?.roughness.contents = UIImage(named: shapeDatasource[shapeIndex].texture)
      box.firstMaterial?.metalness.contents = Finish.init(rawValue: shapeDatasource[shapeIndex].finish)?.image
      scnScene.rootNode.addChildNode(SCNNode(geometry: box))
    case 1:
      let cylinder = geometry[0] as! SCNCylinder
      cylinder.height = CGFloat(data[1].value)
      cylinder.firstMaterial?.diffuse.contents = UIImage(named: shapeDatasource[shapeIndex].texture)
      scnScene.rootNode.addChildNode(SCNNode(geometry: cylinder))
    case 2:
      let sphere = geometry[0] as! SCNSphere
      sphere.radius = CGFloat(0.25 * Double(data[2].value))
      sphere.firstMaterial?.diffuse.contents = Finish.init(rawValue: shapeDatasource[shapeIndex].finish)?.image
      scnScene.rootNode.addChildNode(SCNNode(geometry: sphere))
    default:
      break
//      let bundle = Bundle.main
//      let path = bundle.path(forResource: "test", ofType: "obj")
//      let url = URL(fileURLWithPath: path!)
//      let asset = MDLAsset(url: url)
//
//      guard let object = asset.object(at: 0) as? MDLMesh else {return}
//      let newNode = SCNNode(mdlObject: object)
//      newNode.scale = SCNVector3(0.1, 0.1, 0.1)
//      newNode.position = SCNVector3(-1, 1, -20)
////      let color = UIColor.black
////      newNode.geometry?.firstMaterial?.diffuse.contents = color
//      scnScene.rootNode.addChildNode(newNode)
//
//      let lightNode = SCNNode()
//      lightNode.light = SCNLight()
//      lightNode.light?.type = .omni
//      lightNode.light?.color = UIColor.yellow
//      lightNode.position = SCNVector3(-1, 4, -20)
////      scnScene.rootNode.light = lightNode.light
//      scnScene.rootNode.addChildNode(lightNode)
//
//      geometryNode = newNode
    }
  }



  override var shouldAutorotate: Bool {
    return true
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

}

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func random() -> UIColor {
    return UIColor(
    red: .random(),
    green: .random(),
    blue: .random(),
    alpha: 1.0
    )
  }
  
  func toUIImage() -> UIImage? {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    UIGraphicsGetCurrentContext()!.setFillColor(self.cgColor)
    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
}
