
import UIKit
import RealmSwift
import os.log

class AddViewController: UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  var Dream:DreamModel = DreamModel()
  var addID:String! = nil
  
  @IBOutlet weak var tfTitle: UITextField!
  @IBOutlet weak var tfMemo: UITextView!
  @IBOutlet weak var imgView: UIImageView!

  @IBOutlet weak var saveButton: UIButton!



  override func viewDidLoad() {
    super.viewDidLoad()

    //ボタンstyle
    saveButton.layer.cornerRadius = 3.0

    //tfMemoStyle
    tfMemo.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    tfMemo.layer.borderWidth = 1.0
    tfMemo.layer.cornerRadius = 5.0

    //////////UIToolBarの設定////////////////////
    //UITextViewのインスタンスを生成
    let textView: UITextView = UITextView()
    let toolBar = UIToolbar()
    toolBar.barStyle = .blackTranslucent
    toolBar.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
    toolBar.sizeToFit()

    //Doneボタンを右に配置するためのスペース
    let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    let doneButton = UIBarButtonItem(title: "完了",style: .plain,target: self,action: #selector(AddViewController.doneButton))
    doneButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    doneButton.title = "完了"

    //ツールバーにボタンを設定
    toolBar.items = [space,doneButton]
    tfTitle.inputAccessoryView = toolBar
    tfMemo.inputAccessoryView = toolBar

    //Viewに追加
    self.view.addSubview(textView)

    //ナビゲーションバーStyle
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 1)
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]


    //////////UIToolBarの設定////////////////////
    tfTitle.delegate = self as UITextFieldDelegate

    //既存の編集の時には表示情報を設定
    if let Dream:DreamModel = Dream {
      
      addID = Dream.id
      tfTitle.text = Dream.title
      tfMemo.text = Dream.memo
      if let imgData = Dream.img {
        let img: UIImage? = UIImage(data: imgData as Data)
        imgView.image = img
      }

    }

  }



  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    // The info dictionary may contain multiple representations of the image. You want to use the original.
    guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    
    // Set photoImageView to display the selected image.
    imgView.image = selectedImage
    
    // Dismiss the picker.
    dismiss(animated: true, completion: nil)
  }


  @objc func doneButton(){
    //キーボードを閉じる
    self.view.endEditing(true)
  }


  @IBAction func selectImageView(_ sender: UITapGestureRecognizer) {
    // Hide the keyboard.
    tfTitle.resignFirstResponder()
    tfMemo.resignFirstResponder()

    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    let imagePickerController = UIImagePickerController()

    // Only allow photos to be picked, not taken.
    imagePickerController.sourceType = .photoLibrary

    // Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
    
  }
  

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    let isPresentingInAddMealMode = presentingViewController is UINavigationController

    if isPresentingInAddMealMode {
      dismiss(animated: true, completion: nil)
      print ("キャンセルしたよー")
    }
    else if let owningNavigationController = navigationController{
      owningNavigationController.popViewController(animated: true)
    }
    else {
      fatalError("The MealViewController is not inside a navigation controller.")
    }
  }


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard let Button = sender as? UIButton, Button === saveButton else {
      os_log("ダメでした☠️", log: OSLog.default, type: .debug)
      return
    }
    
    // 新規でデータを追加
    if (addID == nil) {
      // Dream.id = NSUUID().uuidString
      Dream.title = self.tfTitle.text ?? "未入力"
      Dream.memo = self.tfMemo.text ?? "未入力"
      Dream.img = self.imgView.image!.pngData() as NSData?

      let RealmInstance = try! Realm()

      try! RealmInstance.write {
        RealmInstance.add(Dream)

      }

    // 既存データの更新
    }else{

      let RealmInstance = try! Realm()
      let Dreams = RealmInstance.objects(DreamModel.self).filter("id == %@", "addID")
      print("アイヤー！")
      print(Dreams)
      Dream.title = self.tfTitle.text ?? "未入力"
      Dream.memo = self.tfMemo.text ?? "未入力"
      Dream.img = self.imgView.image!.pngData() as NSData?

      try! RealmInstance.write {
        RealmInstance.add(Dream, update: true)
      }
    }
  }

}


