//
//  AlbumViewController.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/03/29.
//

import UIKit
import SceneKit
import ModelIO

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    
    var twoCard = (UIScreen.main.bounds.width / 2) - 20
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40 , height: twoCard * 1.5)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: AlbumCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  var modelDatasource: [ObjectModel] = []
  
  init(datasource: [ObjectModel]) {
    self.modelDatasource = datasource
    print(datasource)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    view.backgroundColor = .white
    
    view.addSubview(collectionView)
    collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
  }
  
  private func get3Dobjs() {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
      return AlbumCollectionViewCell()
    }
    
    let item = modelDatasource[indexPath.row]
    guard let sphere = cell.sphere, let box = cell.box, let cylinder = cell.cylinder else {return cell}
    guard let sphereNode = cell.node, let boxNode = cell.boxNode, let cylinderNode = cell.cylinderNode else {return cell}
    
    //Transparency
    sphere.firstMaterial?.transparency = CGFloat(item.sphere?.transparency ?? 1.0)
    box.firstMaterial?.transparency = CGFloat(item.cube?.transparency ?? 1.0)
    cylinder.firstMaterial?.transparency = CGFloat(item.cylinder?.transparency ?? 1.0)
      
    //Color & Image
    var colorRGB = item.sphere!.color.split(separator: " ").map { CGFloat(Float($0)!)}
    let color = UIColor(red: colorRGB[0], green: colorRGB[1], blue: colorRGB[2], alpha: colorRGB[3])
    sphere.firstMaterial?.diffuse.contents = color
    box.firstMaterial?.diffuse.contents = UIImage(data: item.cube?.image ?? Data())
    cylinder.firstMaterial?.diffuse.contents = UIImage(data: item.cylinder?.image ?? Data())
    
    //Size
    box.width = CGFloat(item.cube?.size?.width ?? 1.0)
    box.height = CGFloat(item.cube?.size?.height ?? 1.0)
    box.length = CGFloat(item.cube?.size?.length ?? 1.0)
    
    cylinder.radius = CGFloat(item.cylinder?.size?.radius ?? 1.0)
    cylinder.height = CGFloat(item.cylinder?.size?.height ?? 1.0)
    
    sphereNode.scale.x = item.sphere?.size?.radius ?? 1.0
    sphereNode.scale.y = item.sphere?.size?.height ?? 1.0
    sphereNode.scale.z = item.sphere?.size?.radius ?? 1.0
    
    //position
    sphereNode.position = item.sphere?.position?.toVector() ?? SCNVector3(x: 0, y: 0, z: 0)
    boxNode.position = item.cube?.position?.toVector() ?? SCNVector3(x: 0, y: 0, z: 0)
    cylinderNode.position = item.cylinder?.position?.toVector() ?? SCNVector3(x: 0, y: 0, z: 0)
    
    //Information
    cell.domainLabel.text = item.domain
    cell.colorHexLabel.text = hexStringFromColor(color: color)
    cell.materialLabel.text = item.cube!.imageName
    cell.finishLabel.text = item.cylinder!.imageName
    cell.importanceArray = ["\(Int(item.sphere!.size!.radius ?? 0))", "\(Int(item.cube!.size!.width ?? 0))", "\(Int(item.cylinder!.size?.radius ?? 0))"]
    cell.funcEmoArray = ["\(Int(item.sphere!.size!.height ?? 0))", "\(Int(item.cube!.size!.height ?? 0))", "\(Int(item.cylinder!.size?.height ?? 0))"]
    cell.timeLabel.text = item.time
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return modelDatasource.count
  }
  
  func hexStringFromColor(color: UIColor) -> String {
      let components = color.cgColor.components
      let r: CGFloat = components?[0] ?? 0.0
      let g: CGFloat = components?[1] ?? 0.0
      let b: CGFloat = components?[2] ?? 0.0

      let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
      return hexString
   }
  
}
