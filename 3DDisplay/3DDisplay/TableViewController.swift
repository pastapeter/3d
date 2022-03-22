//
//  TableViewController.swift
//  SceneKitPractice
//
//  Created by abc on 2022/02/09.
//

import UIKit

class TableViewController: UITableViewController {
  
  private let datasource: [Int] = ShapeType.allCases.map { $0.rawValue }
  var questionData: [Question] = []
  var shapeDatasource: [(texture: String, color: UIColor, finish: String)] = [
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: ""),
    (texture: "", color: UIColor.black, finish: "")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    print(shapeDatasource)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
      cell.titleLabel.text = ShapeType(rawValue: datasource[indexPath.row])!.description
      // 5 8 11
      var questionNum = ""
      switch indexPath.row {
      case 0:
        questionNum += "1-5/1-6"
      case 1:
        questionNum += "1-8/1-9"
      case 2:
        questionNum += "1-11/1-12"
      case 3:
        questionNum += "1-5/1-6, 1-8/1-9, 1-11/1-12"
      default:
        break
      }
      cell.descLabel.text = questionNum
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let board = UIStoryboard(name: "Main", bundle: nil)
    let vc = board.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    vc.shapeIndex = indexPath.row
    vc.data = questionData
    vc.shapeDatasource = shapeDatasource
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
