//
//  movedAlbumViewController.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/05/01.
//

import UIKit
import SceneKit

class MovedAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 0
    
    var twoCard = (UIScreen.main.bounds.width / 2) - 30
    layout.itemSize = CGSize(width: twoCard , height: twoCard * 1.5)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: AlbumCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  var modelDatasource: [MovedModel] = []
  
  init(datasource: [MovedModel]) {
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
    collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return modelDatasource.count
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
    cell.domainLabel.isHidden = true
    cell.colorHexLabel.isHidden = true
    cell.materialLabel.isHidden = true
    cell.finishLabel.isHidden = true
    cell.importanceLabels.forEach {
      $0.isHidden = true
    }
    cell.funcEmoLabels.forEach {
      $0.isHidden = true
    }
    cell.timeLabel.isHidden = true
    cell.firstStackview.isHidden = true
    cell.secondStackView.isHidden = true
    cell.thirdStackView.isHidden = true
    cell.forthStackView.isHidden = true
    
    return cell
  }
  
  
}
