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
  
  @IBOutlet weak var optionPicker: UIPickerView!
  private var domain = Domain.allCases
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func gotoSample() {
    self.present(SampleViewController(), animated: true, completion: nil)
  }
  
  @IBAction func gotoResult(_ sender: UIButton) {
    self.present(AlbumViewController(), animated: true)
  }
  
}

extension firstOptionViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return domain.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return domain[row].rawValue
  }
  
}


extension firstOptionViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    guard let vc = MainViewController.loadFromStoryboard() as? MainViewController else {return}
    vc.domain = domain[row].rawValue
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
