//
//  ShapeType.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/09.
//

import Foundation
import SceneKit

enum ShapeType: Int, CaseIterable, CustomStringConvertible {
  var description: String {
    switch self {
    case .box:
      return "box"
    case .sphere:
      return "sphere"
    case .cylinder:
      return "cylinder"
//    case .boxCylindersphere:
//      return "box&cylinder&sphere"
    }
  }
  
  case box = 0
  case cylinder
  case sphere
//  case boxCylindersphere
}

extension ShapeType {
  
  var geoMetries: [SCNGeometry] {
    switch self {
    case .box:
      return [SCNBox()]
    case .sphere:
      return [SCNSphere()]
    case .cylinder:
      return [SCNCylinder()]
//    case .boxCylindersphere:
//      return [SCNBox(), SCNCylinder(), SCNSphere()]
    }
  }
  
}
