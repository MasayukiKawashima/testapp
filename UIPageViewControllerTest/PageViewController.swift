//
//  PageViewController.swift
//  UIPageViewControllerTest
//
//  Created by 川島真之 on 2022/05/10.
//

import UIKit
import RealmSwift

class PageViewController: UIPageViewController {

  private var controllers: [ViewController] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      initPageView()
    }
  
  func initPageView () {
    
    let vc = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
   
    self.controllers.append(vc)
    print(controllers)
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
    
    self.dataSource = self
    self.delegate = self
  }
}

extension PageViewController: UIPageViewControllerDataSource {
  
  enum Direction {
    case previous,next
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.controllers.count
  }
  
  func instantiate(direction: Direction) -> ViewController? {
    let currentVC = self.viewControllers![0] as! ViewController
    let VC = storyboard?.instantiateViewController(withIdentifier: "View") as! ViewController
    
    switch direction {
    case .previous:
      let nextIndex = currentVC.index - 1
      VC.index = nextIndex
      return VC
    case .next:
      let nextIndex = currentVC.index + 1
      VC.index = nextIndex
      return VC
    }
  }
  //右スワイプ（左から右にスワイプ）戻る
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//    let currentVC = self.viewControllers![0] as! ViewController
//    let VC = storyboard?.instantiateViewController(withIdentifier: "View") as! ViewController
//    let nextIndex = currentVC.index - 1
//    VC.index = nextIndex
    
  //次のVCに現在の日にちに１をたした日にちを渡す
    //if let receivedDate = currentVC.receivedDate {
      //let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: receivedDate)!
      //VC.receivedDate = modifiedDate
      //self.controllers.append(VC)
    //}else{
      //print("日付更新エラー")
    //}
    //VC.receivedStr = dateFomatter.string(from: modifiedDate)
    return instantiate(direction: .previous)
  }
  //左スワイプ（右から左にスワイプ）進む
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//    let currentVC = self.viewControllers![0] as! ViewController
//    let VC = storyboard?.instantiateViewController(withIdentifier: "View") as! ViewController
//    let nextIndex = currentVC.index + 1
//    VC.index = nextIndex
    
    //if let receivedDate = currentVC.receivedDate {
      //let modifiedDate = Calendar.current.date(byAdding: .day, value: +1, to: receivedDate)!
      //VC.receivedDate = modifiedDate
      //self.controllers.append(VC)
    //}else{
      //print("日付更新エラー")
    //}
    return instantiate(direction: .next)
  }
}

extension PageViewController: UIPageViewControllerDelegate {
  //遷移が始まる時に呼ばれるメソッド
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    
    let nextVC = pendingViewControllers.first! as! ViewController
    let dateSet = DateSetModel()
    dateSet.dateSet(viewController: nextVC)
    
    //次ページのデータが既にあるかを確認
    let checkDateData = CheckDateDataModel()
    let results = checkDateData.checkDateData(viewController: nextVC)
    let count = results.count
    if count != 0 {
      nextVC.textField.text = results[0].textFieldString
      if results[0].fileURL != "" {
        let fileURL = URL(string: results[0].fileURL)
        let filePath = fileURL?.path
        nextVC.photoImageView.image = UIImage(contentsOfFile: filePath!)
      }
    }
    
//    let currentVC = self.viewControllers![0] as! ViewController
//    if let direction = nextVC.direction {
//      switch direction {
//      case .next:
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: +1, to: currentVC.date)
//        nextVC.date = modifiedDate
//        let dateFomatter = DateFormatter()
//        dateFomatter.dateFormat = "yyyy/MM/dd"
//        nextVC.dateLabel.text = dateFomatter.string(from: nextVC.date)
//        self.controllers.append(nextVC)
//      case .previous:
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: currentVC.date)
//        nextVC.date = modifiedDate
//        let dateFomatter = DateFormatter()
//        dateFomatter.dateFormat = "yyyy/MM/dd"
//        nextVC.dateLabel.text = dateFomatter.string(from: nextVC.date)
//        self.controllers.append(nextVC)
//      }
//    }else{
//      print("directionがnilです")
//    }
    
    
  }
}
