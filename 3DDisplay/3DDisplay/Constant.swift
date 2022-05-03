//
//  Constant.swift
//  3DDisplay
//
//  Created by abc on 2022/03/17.
//

import UIKit

/*
 <전역변수 모음집 파일>
 
 누나가 여기서 textureDic에서 각각 원하는것 변경해서 넣으면 될거야
 Finish를 추가할때는
  1. 아래 enum Finish 에서 선언을 먼저 하고
  2. 그리고 textureDic에 추가하면 되는 거임
 
 [ Texture:[Finish들], Texture:[Finish들], Texture:[Finish들] ]
 */

var textureDic = ["Wood":[Finish.Polished, Finish.Natural],
                  "Metal": [Finish.Polished, Finish.Brushed, Finish.Matte],
                  "Leather": [Finish.Soft, Finish.Perforated],
                  "Plastic": [Finish.Polished, Finish.Frosted],
                  "Glass": [Finish.Glossy, Finish.Iridescent]
]


enum Finish: String, CaseIterable {

  case Brushed
  case Polished
  case Natural // natural finish image를 추가하삼
  case Soft // soft finish image를 추가하삼
  case Frosted // frosted finish image를 추가하삼
  case Iridescent // iridescent finish image를 추가하삼
  case Glossy
  case Grained
  case Matte
  case Perforated
  
  
  var image: UIImage {
    return UIImage(named: self.rawValue)!
  }
}
