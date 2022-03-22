//
//  QuestionTableViewCell.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/12.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
  
  static let identifier = "QuestionTableViewCell"
  static let nibName = "QuestionTableViewCell"
  @IBOutlet weak var questionSlider: UISlider!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var questionValueLabel: UILabel!
  
  var index: Int = 0
  var updateValue: ((_ index: Int, _ value: Int) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  @IBAction func didSliderChanged(_ sender: UISlider) {
    questionValueLabel.text = "\(Int(sender.value))"
    updateValue?(index, Int(sender.value))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
