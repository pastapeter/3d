//
//  GeometryInfos.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/04/14.
//

import UIKit
import SceneKit

struct CubeInfo {
  var position: SCNVector3 = SCNVector3(x: 1, y: 1, z: 0)
  var image: UIImage = UIImage()
  var name: String = "cube"
  var size: (width: CGFloat, height: CGFloat, length: CGFloat)
  var transparency: CGFloat = 1
}

struct SphereInfo {
  var position: SCNVector3 = SCNVector3(x: 4, y: 1, z: 4)
  var color: UIColor = .red
  var name: String = "sphere"
  var radius: CGFloat = 0.5
  var height: CGFloat = 0.5
  var transparency: CGFloat = 1
}

struct CylinderInfo {
  var position: SCNVector3 = SCNVector3(x: 7, y: 1, z: 0)
  var image: UIImage = UIImage()
  var name: String = "cylinder"
  var size: (radius: CGFloat, height: CGFloat) = (radius: 0.5, height: 1)
  var transparency: CGFloat = 1
}
