//
//  SampleViewController.swift
//  3DDisplay
//
//  Created by abc on 2022/03/17.
//

import UIKit

class SampleViewController: UIViewController {

  let imageView = UIImageView()
  let titleLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    titleLabel.text = "PROTOTYPE"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(titleLabel)
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    
    imageView.contentMode = .scaleAspectFit
    view.addSubview(imageView)
    imageView.image = UIImage(named: "PROTOTYPE")!
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    
    imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    // Do any additional setup after loading the view.
  }
  
  
}
