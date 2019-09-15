
import UIKit
import RealmSwift
import os.log

class MainListViewController: UITableViewController {
  var DreamList: Results<DreamModel>!
  var Dream:DreamModel = DreamModel()
  @IBOutlet var myTableView: UITableView!


  override func viewDidLoad() {
    super.viewDidLoad()
    let RealmInstance = try! Realm()
    self.DreamList = RealmInstance.objects(DreamModel.self)
    self.myTableView.reloadData()

    //テーブルビューStyle
    self.myTableView.rowHeight =  100

    print("ドリームリストの出力")
    print(DreamList)

    //ナビゲーションバーStyle
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 1)
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
  }

  @IBAction func unwindToMainList(sender: UIStoryboardSegue) {
    self.myTableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch(segue.identifier ?? "") {

      case "addDream":
        os_log("新しい夢を追加するぜ！", log: OSLog.default, type: .debug)

      case "showDetail":
        guard let dreamDetailViewController = segue.destination as? AddViewController else {
          fatalError("そんな遷移先、無くないっすか？")
        }
        guard let selectedCell = sender as? MainListCell else {
          fatalError("そんなセル、無くないっすか？")
        }
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
          fatalError("なんか何番目のセルかわかんなかったわ")
        }
        let selectedDream = DreamList[indexPath.row]
        os_log("既存の夢を編集するぜ！", log: OSLog.default, type: .debug)
        print("呼び出し\(selectedDream)")
        dreamDetailViewController.Dream = selectedDream

      default:
        fatalError("あかん！あかんで！")

    }
  }
}


extension MainListViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.DreamList.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listCell:MainListCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! MainListCell
    let item: DreamModel = self.DreamList[(indexPath as NSIndexPath).row];
    listCell.cellTitle?.text = "title：" + item.title
    listCell.cellMemo?.text = "memo：" + item.memo
    listCell.cellBudget?.text = "budget：" + String(item.budget)
    if let targetDate = item.targetDate {
      let formatter = DateFormatter()
      formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
      listCell.cellTargetDate?.text = "目標日：\(formatter.string(from: targetDate))"
    }else{
      os_log("目標日はないよ")
      listCell.cellTargetDate?.text = "目標日：未定"
    }
    if let data = item.img {
      let image: UIImage? = UIImage(data: data as Data)
      listCell.cellImg?.image = image
    }
    listCell.cellDoneFlag = item.doneFlag
    if listCell.cellDoneFlag {
      print("完了してるcell")
      listCell.backgroundColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 0.1)
    } else {
      listCell.backgroundColor = UIColor.clear
    }
    return listCell
  }

  //スライドして削除
  //  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
  //
  //    if editingStyle == .delete {
  //      do{
  //        let realm = try Realm()
  //        try realm.write {
  //          realm.delete(self.DreamList[indexPath.row])
  //        }
  //        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
  //      }catch{
  //        os_log("削除できんかったわ")
  //      }
  //      tableView.reloadData()
  //    }
  //  }

  func doneAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .normal, title: "DONE") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
      print("完了しました")
      let realm = try! Realm()
      try! realm.write {
        if self.DreamList[indexPath.row].doneFlag {
          print("処理前\(self.DreamList[indexPath.row])")
          self.DreamList[indexPath.row].doneFlag = false
          print("処理後\(self.DreamList[indexPath.row])")

        }else{
          print("処理前\(self.DreamList[indexPath.row])")
          self.DreamList[indexPath.row].doneFlag = true
          print("処理後\(self.DreamList[indexPath.row])")
        }
        realm.add(self.DreamList[indexPath.row], update: true)
        self.myTableView.reloadData()
      }
      completionHandler(true)
    }
    action.backgroundColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 1)
    return action
  }

  func deleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
      print("消しました")
      let realm = try! Realm()
      try! realm.write {
        realm.delete(self.DreamList[indexPath.row])
      }
      completionHandler(true)
    }
    return action
  }
    
  @available(iOS 11.0, *)
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let doneAction = self.doneAction(forRowAtIndexPath: indexPath)
    let deleteAction = self.deleteAction(forRowAtIndexPath: indexPath)
    return UISwipeActionsConfiguration(actions: [doneAction, deleteAction])
  }
}
