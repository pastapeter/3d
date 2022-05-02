//
//  objectModel.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/04/15.
//

import Foundation
import UIKit
import RealmSwift
import SceneKit

class ObjectModel: Object {
  
  @Persisted(primaryKey: true) var id: ObjectId
  
  @Persisted var domain: String

  @Persisted var time: String
  
  @Persisted var importanceForColor: Int
  
  @Persisted var FunctionalAndEmotionalForColor: Int
  
  @Persisted var importanceForMateiral: Int
  
  @Persisted var FunctionalAndEmotionalForMaterial: Int
  
  @Persisted var URL: String
  
  @Persisted var cube: Cube?
  
  @Persisted var sphere: Sphere?
  
  @Persisted var cylinder: Cylinder?
  
  convenience init(time: Date, totalModel: TotalModel, cube: CubeInfo, sphere: SphereInfo, cylinder: CylinderInfo) {
    self.init()
    self.domain = totalModel.domain
    self.time = time.toString()
    self.importanceForColor = totalModel.importanceForColor
    self.FunctionalAndEmotionalForColor = totalModel.FunctionalAndEmotionalForColor
    self.importanceForMateiral = totalModel.importanceForMaterial
    self.FunctionalAndEmotionalForMaterial = totalModel.FunctionalAndEmotionalForMaterial
//    self.URL = totalModel.URL.absoluteString
    self.cube = Cube(position: (x: cube.position.x, y: cube.position.y, z: cube.position.z),
                     image: cube.image,
                     name: cube.name,
                     size: (width: cube.size.width, height: cube.size.height, length: cube.size.length),
                     transparency: cube.transparency)
    self.sphere = Sphere(position: (x: sphere.position.x, y: sphere.position.y, z: sphere.position.z),
                         color: sphere.color,
                         name: sphere.name,
                         size: (radius: sphere.radius, height: sphere.height),
                         transparency: sphere.transparency)
    self.cylinder = Cylinder(position: (x: cylinder.position.x, y: cylinder.position.y, z: cylinder.position.z),
                             image: cylinder.image,
                             name: cylinder.name,
                             size: (radius: cylinder.size.radius, height: cylinder.size.height),
                             transparency: cylinder.transparency)
  }
    
}

class Cube: Object {
  
  @Persisted var position: Position?
  @Persisted var image: Data?
  @Persisted var imageName: String
  @Persisted var name: String
  @Persisted var size: Size?
  @Persisted var transparency: Float
  
  convenience init(position: (x: Float, y: Float, z: Float), image: UIImage, name: String, size: (width: CGFloat, height: CGFloat, length: CGFloat), transparency: CGFloat) {
    self.init()
    self.position = Position(x: position.x, y: position.y, z: position.z)
    self.imageName = name
    self.image = image.pngData()
    self.name = "cube"
    self.transparency = Float(transparency)
    self.size = Size(width: Float(size.width), height: Float(size.height), radius: nil, length: Float(size.length))
    
  }
  
}

class Sphere: Object {
  
  @Persisted var position: Position?
  @Persisted var color: String
  @Persisted var name: String
  @Persisted var size: Size?
  @Persisted var transparency: Float
  
  convenience init(position: (x: Float, y: Float, z: Float), color: UIColor, name: String, size: (radius: CGFloat, height: CGFloat), transparency: CGFloat) {
    self.init()
    self.position = Position(x: position.x, y: position.y, z: position.z)
    self.color = color.toString()
    self.name = name
    self.transparency = Float(transparency)
    self.size = Size(width: nil, height: Float(size.height), radius: Float(size.radius), length: nil)
  }
  
}

class Cylinder: Object {
  
  @Persisted var position: Position?
  @Persisted var image: Data?
  @Persisted var name: String
  @Persisted var imageName: String
  @Persisted var size: Size?
  @Persisted var transparency: Float
  
  convenience init(position: (x: Float, y: Float, z: Float), image: UIImage, name: String, size: (radius: CGFloat, height: CGFloat), transparency: CGFloat) {
    self.init()
    self.position = Position(x: position.x, y: position.y, z: position.z)
    self.image = image.pngData()
    self.imageName = name
    self.name = "cylinder"
    self.transparency = Float(transparency)
    self.size = Size(width: nil, height: Float(size.height), radius: Float(size.radius), length: nil)
  }
  
}

class Position: Object {
  
  @Persisted var x: Float
  @Persisted var y: Float
  @Persisted var z: Float
  
  convenience init(x: Float, y: Float, z: Float) {
    self.init()
    self.x = x
    self.y = y
    self.z = z
  }
  
  func toVector() -> SCNVector3 {
    return SCNVector3(x: x, y: y, z: z)
  }
  
}

class Size: Object {
  
  @Persisted var width: Float?
  @Persisted var height: Float?
  @Persisted var radius: Float?
  @Persisted var length: Float?
  
  convenience init(width: Float? = nil, height: Float? = nil, radius: Float? = nil, length: Float? = nil) {
    self.init()
    self.width = width
    self.height = height
    self.radius = radius
    self.length = length
  }
  
}

extension UIColor {
     func toString() -> String {
          let colorRef = self.cgColor
          return CIColor(cgColor: colorRef).stringRepresentation
     }
 }
