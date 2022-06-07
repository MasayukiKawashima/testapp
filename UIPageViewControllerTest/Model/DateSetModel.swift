//
//  DateSetModel.swift
//  UIPageViewControllerTest
//
//  Created by 川島真之 on 2022/05/27.
//

import Foundation

class DateSetModel {
    func dateSet (viewController: ViewController) {
      let date = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd"
      let modifiedDate = Calendar.current.date(byAdding: .day, value: viewController.index, to: date)
      viewController.date = dateFormatter.string(from: modifiedDate!)
      viewController.dateLabel.text = viewController.date
    }
}
