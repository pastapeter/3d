//
//  TextureTableViewCell.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/13.
//

import UIKit

class TextureTableViewCell: UITableViewCell {
  
  static let identifier = "TextureTableViewCell"
  static let nibName = "TextureTableViewCell"
  
  @IBOutlet weak var colorField: UIButton! {
    didSet {
      colorField.layer.borderColor = UIColor.lightGray.cgColor
      colorField.layer.borderWidth = 1
      colorField.layer.cornerRadius = 5
      colorField.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var materialTextField: UITextField!
  @IBOutlet weak var finishTextField: UITextField!
  
  private var pickerView = UIPickerView()
  var presentColorPicker: ((Int)->Void)?
  var colorViewController: UIColorPickerViewController?
  var index: Int = 0
  var updateColor: ((_ color: UIColor) -> ())?
  private var glossyList = Finish.allCases.map { $0.rawValue }
  var updateUI: ((_ index: Int, _ value: String) -> ())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    pickerView.delegate = self
    pickerView.dataSource = self
    let textfields = [materialTextField, finishTextField]
    textfields.forEach {
      $0?.inputView = pickerView
    }
    addToolbar()
  }

  
  @IBAction func getColorPicker(_ sender: Any) {
    self.presentColorPicker?(index)
  }
  
  @IBAction func textfieldDidChange(_ sender: UITextField) {
    guard let text = sender.text else {return}
    if sender == materialTextField {
      materialTextField.text = text
      updateUI?(1, text)
    } else {
      finishTextField.text = text
      updateUI?(2, text)
    }
  }
  
}

extension TextureTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if  materialTextField.isFirstResponder {
      return textureDic.count
    } else {
      return textureDic[materialTextField.text!]?.count ?? 5
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if  materialTextField.isFirstResponder {
      return Array(textureDic.keys.map{String($0)})[row]
    } else {
      return "\(textureDic[materialTextField.text!]![row])"
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if  materialTextField.isFirstResponder {
      materialTextField.text = Array(textureDic.keys.map{String($0)})[row]
    } else {
      finishTextField.text = "\(textureDic[materialTextField.text!]![row])"
    }
  }
  
  private func addToolbar() {
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    self.materialTextField.inputAccessoryView = toolbar
    self.finishTextField.inputAccessoryView = toolbar
    
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

extension UIColor {
  convenience init(hex: String, alpha: CGFloat = 1.0) { var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    if hexFormatted.hasPrefix("#") { hexFormatted = String(hexFormatted.dropFirst()) }
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha) }
  
}

