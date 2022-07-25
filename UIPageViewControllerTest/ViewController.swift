//
//  ViewController.swift
//  UIPageViewControllerTest
//
//  Created by 川島真之 on 2022/05/10.
//

import UIKit
import RealmSwift

class ViewController: UIViewController{
  
  @IBOutlet weak var textField: UITextField!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var photoImageView: UIImageView!
  
  var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  
  var index: Int = 0
  
  var date: String = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textField.delegate = self
    
    let dateSet = DateSetModel()
    dateSet.dateSet(viewController: self)
    
    let checkDateData = CheckDateDataModel()
    let results = checkDateData.checkDateData(viewController: self)
    let count = results.count
    
    if count != 0 {
      self.textField.text = results[0].textFieldString
      if results[0].fileURL != "" {
        let fileURL = URL(string: results[0].fileURL)
        let filePath = fileURL?.path
        self.photoImageView.image = UIImage(contentsOfFile: filePath!)
      }
    }
    // Do any additional setup after loading the view.
    //recivedDateに値が入っていたらそれを使い
    //if let recivedDate = self.receivedDate {
    //let dateFomatter = DateFormatter()
    //dateFomatter.dateFormat = "yyyy/MM/dd"
    
    //self.dateLabel.text = dateFomatter.string(from: recivedDate)
    //}else{
    //入っていなかったら今日の日付を代入
    //    self.date = Date()
    //    let dateFomatter = DateFormatter()
    //    dateFomatter.dateFormat = "yyyy/MM/dd"
    //
    //    self.dateLabel.text = dateFomatter.string(from: date!)
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
}
//
extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    //データベースに現在のページの日付のデータがあるかを確認
  let checkDateData = CheckDateDataModel()
  let results = checkDateData.checkDateData(viewController: self)
  let count = results.count
    //入力された文字が空の場合
    if textField.text == "" {
      //データがなければ
      if (count == 0) {
      print("データなし。文字が空です")
      return true
      }else{
        let realm = try! Realm()
        try! realm.write() {
          results[0].textFieldString = textField.text!
          print("からの文字を更新しました")
          print(results)
        }
      }
      //文字列が空じゃなかったら
      //今日の日付のデータを作る
    }else{
      let realm = try! Realm()
      if (count == 0) {
        let dateData = DateDataModel()
        dateData.date = self.date
        dateData.textFieldString = textField.text!
        try! realm.write {
          realm.add(dateData)
        }
        let results = realm.objects(DateDataModel.self)
        print(results)
        //もしデータがあれば更新
      }else{
        //do{
          try! realm.write() {
            results[0].textFieldString = textField.text!
            print("更新しました")
            print(results)
          }
        //}catch{
          //print("更新エラー")
        //}
      }
    }
    return true
  }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @IBAction func tapView(_ sender: Any) {
    
    //アクションシート
    let actionSheet = UIAlertController(title: "写真の選択", message: nil, preferredStyle: .actionSheet)
    //カメラ
    let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default) { action in
      
      let sourceType = UIImagePickerController.SourceType.camera
      if UIImagePickerController.isSourceTypeAvailable(sourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
  }
    //フォトライブラリ
    let photoLibraryAction: UIAlertAction = UIAlertAction(title: "フォトライブラリ", style: UIAlertAction.Style.default) { action in
      
      let sourceType = UIImagePickerController.SourceType.photoLibrary
      if UIImagePickerController.isSourceTypeAvailable(sourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
      }
    }
    //キャンセル
    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { action in
      self.dismiss(animated: true, completion: nil)
    }
    //各アクションをアクションシートに追加
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(photoLibraryAction)
    actionSheet.addAction(cancelAction)
    //アクションシートをモーダル表示
    present(actionSheet, animated: true, completion: nil)
 }
  //カメラ及びフォトライブラリでキャンセルしたときのデリゲートメソッド
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  //画像を選択したときのデリゲートメソッド
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let pickedImage = info[.originalImage] as? UIImage {
      self.photoImageView.contentMode = .scaleAspectFit
      self.photoImageView.image = pickedImage
      
      //画像をドキュメントに保存
      saveImageToDocument(pickedImage: pickedImage)
      
      //データベースの確認
      let results = CheckDateDataModel().checkDateData(viewController: self)
      let count = results.count
      
      //データがなかったらその日のデータを作成
      if count == 0 {
        let realm = try! Realm()
        let dateData = DateDataModel()
        dateData.date = self.date
        dateData.fileURL = documentDirectoryFileURL.absoluteString
        try! realm.write {
          realm.add(dateData)
        }
      }else{
        //データがあったら
        //さらに写真のデータがあるかを確認し、
        let realm = try! Realm()
        if results[0].fileURL != "" {
          //あれば古いデータをドキュメントから削除し
          let fileURL = URL(string: results[0].fileURL)
          let filePath = fileURL?.path
          
          if filePath != nil {
            //ドキュメントから削除するメソッドremoveItem()
            //この関数は引数にパスを取るので上でURLのpathプロパティの値を取得している
            try? FileManager.default.removeItem(atPath: filePath!)
          }
        }
        //その後あたらしいデータをいれる
        try! realm.write() {
          results[0].fileURL = documentDirectoryFileURL.absoluteString
      }
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  //ドキュメントへ保存する写真のフルパスを作るメソッド
  func createImageFilePath () {
    
    let fileName = "\(NSUUID().uuidString)"
    
    if documentDirectoryFileURL != nil {
      let path = documentDirectoryFileURL.appendingPathComponent(fileName)
      documentDirectoryFileURL = path
    }
  }
  //ドキュメントへ写真を保存するメソッド
  //ひとまずPNGとして保存する。ファイル形式については要確認。
  func saveImageToDocument (pickedImage: UIImage) {
    
    createImageFilePath()
    
    let pngImageData = pickedImage.pngData()
    do {
      try pngImageData!.write(to: documentDirectoryFileURL)
    } catch {
      print("画像をドキュメントに保存できませんでした")
    }
  }
}
}
