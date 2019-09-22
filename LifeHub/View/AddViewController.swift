
import UIKit
import RealmSwift
import os.log

class AddViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  //変数
  var Dream:DreamModel = DreamModel()
  var addID:String! = nil
  var addDate:Date! = nil
  var datePicker: UIDatePicker = UIDatePicker()

  // パーツ
  @IBOutlet weak var tfTitle: UITextField!
  @IBOutlet weak var tfMemo: UITextView! {didSet{
    tfMemo.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    tfMemo.layer.borderWidth = 1.0
    tfMemo.layer.cornerRadius = 5.0
  }}
  @IBOutlet weak var tfDate: UITextField!
  @IBOutlet weak var tfBudget: UITextField!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var saveButton: UIButton! {didSet{
    saveButton.layer.cornerRadius = 3.0
  }}

  // アクション
  //イメージピッカーを表示
  @IBAction func selectImageView(_ sender: UITapGestureRecognizer) {
    tfTitle.resignFirstResponder()
    tfMemo.resignFirstResponder()
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    /// MARK:スタイルの適用
      self.navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 1)
      self.navigationController?.navigationBar.tintColor = .white
      self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    /// MARK:UIToolBarの設定
      let toolBar = UIToolbar()
      toolBar.barStyle = .blackTranslucent
      toolBar.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
      toolBar.sizeToFit()

      // toolbar用のパーツを作成
      let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
      let doneButton = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(AddViewController.doneButton))
      doneButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
      doneButton.title = "完了"

      //ツールバーにパーツを配置
      toolBar.items = [space,doneButton]

      //テキストフィールドにtoolbarを配置
      tfTitle.inputAccessoryView = toolBar
      tfMemo.inputAccessoryView = toolBar
      tfBudget.inputAccessoryView = toolBar

    /// MARK:既存データのセット

      print("既存データセット")
      print(Dream)
      addID = Dream.id
      tfTitle.text = Dream.title
      tfMemo.text = Dream.memo
    if Dream.budget == 0 {
      tfBudget.text = ""
    }else{
      tfBudget.text = String(Dream.budget)
    }
      if let targetDate = Dream.targetDate {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        tfDate.text = "\(formatter.string(from: targetDate))"
        addDate = targetDate
      }else{
        os_log("目標日はないよ")
      }
      if let imgData = Dream.img {
        imgView.image = UIImage(data: imgData as Data)
      }


    /// MARK:日付の入力
      // ピッカー設定
      datePicker.datePickerMode = UIDatePicker.Mode.date
      datePicker.timeZone = NSTimeZone.local
      datePicker.locale = Locale.current
      tfDate.inputView = datePicker

      // 日付用の決定バーの生成
      let dateToolBar = UIToolbar()
      dateToolBar.barStyle = .blackTranslucent
      dateToolBar.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
      dateToolBar.sizeToFit()
      let dateDone = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(AddViewController.dateDone))
      dateDone.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
      dateToolBar.items = [space, dateDone]

      // インプットビュー設定(紐づいているUITextfieldへ代入)
      tfDate.inputView = datePicker
      tfDate.inputAccessoryView = dateToolBar
  }

  //写真のアップロード系
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      fatalError("なんかダメでした。")
    }
    imgView.image = selectedImage
    dismiss(animated: true, completion: nil)
  }
  
  // 画面遷移するときの処理
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard let Button = sender as? UIButton, Button === saveButton else {
      print("ただのキャンセル")
      return
    }
    
    // realmインスタンス作成
    let RealmInstance = try! Realm()

    dump(addID)
    if (addID == nil) {
      // 新規でデータを追加
      try! RealmInstance.write {
        Dream.title = self.tfTitle.text!
        Dream.memo = self.tfMemo.text!
        Dream.budget = Int(self.tfBudget.text!) ?? 0
        Dream.targetDate = addDate!
        dump(Dream.targetDate)
        Dream.img = self.imgView.image!.pngData() as NSData?
        RealmInstance.add(Dream)
      }
    }else{
      // 既存データの更新
      try! RealmInstance.write {
        // idから既存データオブジェクトをロード
//        let Dreams = RealmInstance.objects(DreamModel.self).filter("id == %@", "addID")
        print("既存データの内容を出力")
        print(Dream)
        Dream.title = self.tfTitle.text!
        Dream.memo = self.tfMemo.text!
        Dream.budget = Int(self.tfBudget.text!) ?? 0
        Dream.targetDate = addDate
        Dream.img = self.imgView.image!.pngData() as NSData?
        print("この内容で上書きするでー")
        print(Dream)
        RealmInstance.add(Dream, update: true)
      }
    }
  }
}

extension AddViewController {
  //キーボードを閉じる
  @objc func doneButton(){
    self.view.endEditing(true)
  }
  // 日付の入力完了ボタン
  @objc func dateDone() {
    self.view.endEditing(true)
     let formatter = DateFormatter()
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
    addDate = datePicker.date
    tfDate.text = "\(formatter.string(from: datePicker.date))"
  }
}


