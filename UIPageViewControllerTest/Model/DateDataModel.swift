//
//  DateDataModel.swift
//  UIPageViewControllerTest
//
//  Created by 川島真之 on 2022/05/28.
//

import Foundation
import RealmSwift

class DateDataModel: Object {
  @objc dynamic var date: String = ""
  @objc dynamic var textFieldString: String = ""
  @objc dynamic var fileURL : String = ""
  //写真の向き
  @objc dynamic var orientaion: String = ""
  
  override static func primaryKey() -> String? {
    return "date"
  }
}
