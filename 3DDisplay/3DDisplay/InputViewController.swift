//
//  InputViewController.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/12.
//

import UIKit

struct Question {
  var questionTitle: String
  var value: Int
}

class InputViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: QuestionTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: QuestionTableViewCell.identifier)
    tableView.register(UINib(nibName: TextureTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TextureTableViewCell.identifier)
    self.title = navtitleText
    
    presentColorViewController = { [weak self] in
      guard let self = self else {return}
      let colorViewController = UIColorPickerViewController()
      colorViewController.delegate = self
      self.present(colorViewController, animated: true, completion: nil)
    }

  }
  
  var navtitleText: String = "Question"
  var presentColorViewController: (() -> Void)?
  var updateColor: ((UIColor) -> Void)?
  var index = 0
  var datasource: [Question] = [
    Question(questionTitle: "SIZE - box", value: 0),
    Question(questionTitle: "SIZE - cylinder", value: 0),
    Question(questionTitle: "SIZE - sphere", value: 0)
  ]
  var handler: [((UIColor) -> Void)] = []
  
  var shapeDatasource: [(texture: String, color: UIColor, finish: String)] = [
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: "")
  ]
  
  
  @IBAction func didFinishedAllFillOut(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
    vc.questionData = datasource
    vc.shapeDatasource = shapeDatasource
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension InputViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count + shapeDatasource.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row % 2 == 1 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TextureTableViewCell.identifier, for: indexPath) as? TextureTableViewCell else {return TextureTableViewCell()}
      cell.updateUI = { [weak self] (index, value) in
        guard let self = self else {return}
        if index == 1 {
          self.shapeDatasource[indexPath.row / 2 ].texture = value
        } else {
          self.shapeDatasource[indexPath.row / 2 ].finish = value
        }
      }
      cell.index = indexPath.row / 2
      cell.updateColor =  { [weak self] color in
        guard let self = self else {return}
        cell.colorField.backgroundColor = color
        self.shapeDatasource[indexPath.row / 2 ].color = color
      }
      handler.append(cell.updateColor!)
      cell.colorViewController = UIColorPickerViewController()
      cell.presentColorPicker = { [weak self] index in
        guard let self = self else {return}
        self.index = index
        cell.colorViewController!.delegate = self
        self.present(cell.colorViewController!, animated: true, completion: nil)
      }
      
      return cell
      
    } else { // 0, 2, 4
      guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as? QuestionTableViewCell else {return QuestionTableViewCell()}
      
      cell.questionLabel.text = datasource[indexPath.row / 2].questionTitle
      
      cell.index = indexPath.row
      cell.questionSlider.value = Float(datasource[indexPath.row / 2].value)
      cell.updateValue = { [weak self] (index, value)in
        guard let self = self else {return}
        self.datasource[index / 2].value = value
      }
      
      cell.questionSlider.minimumValue = 1
      cell.questionSlider.maximumValue = 5
      
      return cell
    }
   
  }
}

extension InputViewController: UIColorPickerViewControllerDelegate {
  func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
    handler[index](color)
  }
}
