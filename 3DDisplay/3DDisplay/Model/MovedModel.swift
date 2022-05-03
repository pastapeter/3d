//
//  MovedModel.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/05/01.
//

import UIKit
import RealmSwift
import SceneKit

class MovedModel: Object {
  
  @Persisted(primaryKey: true) var id: ObjectId
  
  @Persisted var cube: Cube?
  
  @Persisted var sphere: Sphere?
  
  @Persisted var cylinder: Cylinder?
  
  convenience init(cube: CubeInfo, sphere: SphereInfo, cylinder: CylinderInfo) {
    self.init()
    self.cube = Cube(position: (x: cube.position.x, y: cube.position.y, z: cube.position.z),
                     image: cube.image,
                     name: cube.name,
                     size: (width: cube.size.width, height: cube.size.height, length: cube.size.length),
                     transparency: cube.transparency, imageName: cube.imageName)
    self.sphere = Sphere(position: (x: sphere.position.x, y: sphere.position.y, z: sphere.position.z),
                         color: sphere.color,
                         name: sphere.name,
                         size: (radius: sphere.radius, height: sphere.height),
                         transparency: sphere.transparency)
    self.cylinder = Cylinder(position: (x: cylinder.position.x, y: cylinder.position.y, z: cylinder.position.z),
                             image: cylinder.image,
                             name: cylinder.name,
                             size: (radius: cylinder.size.radius, height: cylinder.size.height),
                             transparency: cylinder.transparency, imageName: cylinder.imageName)
  }
}
