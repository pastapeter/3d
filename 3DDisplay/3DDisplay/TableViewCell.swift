//
//  TableViewCell.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/09.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  static var identifier = "TableViewCell"
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "adfadfadfadfad"
    label.font = .systemFont(ofSize: 16)
    label.textColor = .black
    return label
  }()
  
  lazy var descLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "adfafadsfasdfasdfasdf"
    label.font = .systemFont(ofSize: 12)
    label.textColor = .black
    return label
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .leading
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 3
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
//    contentView.addSubview(titleLabel)
//    contentView.addSubview(descLabel)
//    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
//    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    contentView.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    contentView.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
