//
//  firstOptionViewController.swift
//  3DDisplay
//
//  Created by abc on 2022/03/17.
//

import UIKit

enum Domain: String, CaseIterable {
  case Electronic
  case Furniture
  case Fashion
}

class firstOptionViewController: UIViewController {
  
  @IBOutlet weak var resultButton: UIButton! {
    didSet {
      resultButton.alpha = 0.9
    }
  }
  @IBOutlet weak var everyObject: UILabel!
  @IBOutlet weak var domainTitle: UILabel!
  
  @IBOutlet weak var optionPicker: UIPickerView!
  private var domain = Domain.allCases
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  @IBAction func gotoResult(_ sender: UIButton) {
    self.present(AlbumViewController(), animated: true)
  }
  
  func setup() {
    everyObject.textColor = .label.withAlphaComponent(0.9)
    domainTitle.textColor = .label.withAlphaComponent(0.9)
  }
  
}

extension firstOptionViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return domain.count
  }
  
}


extension firstOptionViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    guard let vc = MainViewController.loadFromStoryboard() as? MainViewController else {return}
    vc.domain = domain[row].rawValue
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let font = UIFont(name: "Gill Sans", size: 21)
    let color = UIColor.label.withAlphaComponent(0.9)
    let text = domain[row].rawValue
    let attributedStr = NSMutableAttributedString(string: text)
    attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: text))
    attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: text))
    return attributedStr
  }
}
