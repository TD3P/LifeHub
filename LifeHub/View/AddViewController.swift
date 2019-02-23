
import UIKit
import RealmSwift
import os.log

class AddViewController: UIViewController {
  let Dream:DreamModel = DreamModel()


  @IBOutlet weak var tfTitle: UITextField!

  @IBOutlet weak var tfMemo: UITextView!
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

    }

  @objc func doneButton(){
      //キーボードを閉じる
      self.view.endEditing(true)
    }


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard let Button = sender as? UIButton, Button === saveButton else {
      os_log("ダメでした☠️", log: OSLog.default, type: .debug)
      return
    }
    Dream.title = self.tfTitle.text ?? "未入力"
    Dream.memo = self.tfMemo.text ?? "未入力"


    let RealmInstance = try! Realm()
    try! RealmInstance.write {
      RealmInstance.add(Dream)
    }
  }

}
