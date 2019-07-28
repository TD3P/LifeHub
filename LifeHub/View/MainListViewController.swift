
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

    return listCell

  }
}
