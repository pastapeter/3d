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
    layout.itemSize = CGSize(width: twoCard, height: twoCard * 1.5)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: AlbumCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  var datasource: [Int] = [1,2,3,4,5,6,7]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    view.backgroundColor = .white
    
    view.addSubview(collectionView)
    collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
  }
  
  private func get3Dobjs() {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
      return AlbumCollectionViewCell()
    }
      
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datasource.count
  }
  
}
