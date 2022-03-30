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
  @IBOutlet weak var questionTextfield: UITextField!
  @IBOutlet weak var stackview: UIStackView!
  @IBOutlet weak var colorField: UIButton! {
    didSet {
      colorField.layer.borderColor = UIColor.lightGray.cgColor
      colorField.layer.borderWidth = 1
      colorField.layer.cornerRadius = 5
      colorField.layer.masksToBounds = true
    }
  }
  
  var index: Int = 0
  var updateValue: ((_ index: Int, _ value: Int) -> Void)?
  private var pickerView = UIPickerView()
  var presentColorPicker: (()->Void)?
  var colorViewController: UIColorPickerViewController?
  var updateColor: ((_ color: UIColor) -> ())?
  var updateUI: ((_ value: String) -> ())?
  private var glossyList = Finish.allCases.map { $0.rawValue }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    pickerView.delegate = self
    pickerView.dataSource = self
    questionTextfield.inputView = pickerView
    addToolbar()
  }
  
  @IBAction func didSliderChanged(_ sender: UISlider) {
    questionValueLabel.text = "\(Int(sender.value))"
    updateValue?(index, Int(sender.value))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  
  @IBAction func textfieldDidEnd(_ sender: UITextField) {
    guard let text = sender.text else {return}
    questionTextfield.text = text
    updateUI?(text)
  }
  
  @IBAction func didTapColorButton(_ sender: UIButton) {
    self.presentColorPicker?()
  }
}

extension QuestionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if  questionTextfield.isFirstResponder {
      return textureDic.count
    } else {
      return textureDic[questionTextfield.text!]?.count ?? 5
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if  questionTextfield.isFirstResponder {
      return Array(textureDic.keys.map{String($0)})[row]
    } else {
      return "\(textureDic[questionTextfield.text!]![row])"
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      questionTextfield.text = Array(textureDic.keys.map{String($0)})[row]
  }
  
  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    self.questionTextfield.inputAccessoryView = toolbar
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let done = UIBarButtonItem()
    done.title = "Done"
    done.target = self
    done.action = #selector(pickerDone(_:))
    
    toolbar.setItems([flexSpace, done], animated: true)
    
  }
  
  @objc private func pickerDone(_ sender: UIPickerView) {
    self.endEditing(true)
  }
  
  
}
  
  
