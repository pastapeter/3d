//
//  firstOptionViewController.swift
//  3DDisplay
//
//  Created by abc on 2022/03/17.
//

import UIKit
import RealmSwift

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
    do {
      let model = try self.getObject()
      
      self.present(AlbumViewController(datasource: model), animated: true)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @IBAction func gotoResult2(_ sender: UIButton) {
    do {
      let model = try self.getMovedObjest()
      
      self.present(MovedAlbumViewController(datasource: model), animated: true)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func setup() {
    everyObject.textColor = .label.withAlphaComponent(0.9)
    domainTitle.textColor = .label.withAlphaComponent(0.9)
  }
  
  private func getObject() throws -> [ObjectModel]{
    do {
      let realm = try Realm()
      let result = Array(realm.objects(ObjectModel.self))
      return result
    } catch {
      print(error.localizedDescription)
      return []
    }
  }
  
  private func getMovedObjest() throws -> [MovedModel] {
    do {
      let realm = try Realm()
      let result = Array(realm.objects(MovedModel.self))
      return result
    } catch {
      print(error.localizedDescription)
      return []
    }
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
