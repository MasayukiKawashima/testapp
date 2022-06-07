//
//  CheckDateDataModel.swift
//  UIPageViewControllerTest
//
//  Created by 川島真之 on 2022/05/29.
//

import Foundation
import RealmSwift

class CheckDateDataModel{
  
  func checkDateData(viewController: ViewController) -> Results<DateDataModel> {
    let realm = try! Realm()
    let results = realm.objects(DateDataModel.self).filter("date == %@", viewController.date)
    return results
  }
}
