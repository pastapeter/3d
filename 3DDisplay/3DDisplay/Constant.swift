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

var textureDic = ["wood":[Finish.brushed, Finish.embossed], "metal": [Finish.grained], "leather": [Finish.matte], "plastic": [Finish.perforated, Finish.polished], "glass": [Finish.glossy]]


enum Finish: String, CaseIterable {
  
  //Wood
  case brushed
  case embossed
  
  //glass
  case glossy
  
  //metal
  case grained
  
  // leather
  case matte
  
  //plastic
  case perforated
  case polished
  
  var image: UIImage {
    return UIImage(named: self.rawValue)!
  }
}
