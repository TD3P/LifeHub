
import UIKit
import RealmSwift
import os.log

class AddViewController: UIViewController {
  let Dream:DreamModel = DreamModel()


  @IBOutlet weak var tfTitle: UITextField!
  @IBOutlet weak var tfMemo: UITextField!
  @IBOutlet weak var saveButton: UIButton!




  override func viewDidLoad() {
    super.viewDidLoad()

    //ボタンstyle
    saveButton.layer.cornerRadius = 3.0

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
