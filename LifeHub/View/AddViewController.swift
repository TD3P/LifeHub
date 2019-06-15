
import UIKit
import RealmSwift
import os.log

class AddViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  //変数
  var Dream:DreamModel = DreamModel()
  var addID:String! = nil

  // パーツ
  @IBOutlet weak var tfTitle: UITextField!
  @IBOutlet weak var tfMemo: UITextView! {didSet{
    tfMemo.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    tfMemo.layer.borderWidth = 1.0
    tfMemo.layer.cornerRadius = 5.0
  }}
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

    /// MARK:既存データのセット
      if let prepareDream:DreamModel = Dream {
        addID = prepareDream.id
        tfTitle.text = prepareDream.title
        tfMemo.text = prepareDream.memo
        if let imgData = prepareDream.img {
          imgView.image = UIImage(data: imgData as Data)
        }
      }
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
    
    // realmインスタンス作成
    let RealmInstance = try! Realm()

    if (addID == nil) {
      // 新規でデータを追加
      try! RealmInstance.write {
        Dream.title = self.tfTitle.text!
        Dream.memo = self.tfMemo.text!
        Dream.img = self.imgView.image!.pngData() as NSData?
        RealmInstance.add(Dream)
      }
    }else{
      // 既存データの更新
      try! RealmInstance.write {
        // idから既存データオブジェクトをロード
        let Dreams = RealmInstance.objects(DreamModel.self).filter("id == %@", "addID")
        print("既存データの内容を出力")
        print(Dream)
        Dream.title = self.tfTitle.text!
        Dream.memo = self.tfMemo.text!
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
}


