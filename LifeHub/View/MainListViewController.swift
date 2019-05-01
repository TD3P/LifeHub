
import UIKit
import RealmSwift

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




    //ナビゲーションバーStyle
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 156/255, blue: 195/255, alpha: 1)
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
  }

  @IBAction func unwindToMainList(sender: UIStoryboardSegue) {
    self.myTableView.reloadData()
  }


}

extension MainListViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.DreamList.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let listCell:MainListCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! MainListCell

    let item: DreamModel = self.DreamList[(indexPath as NSIndexPath).row];

    listCell.cellTitle?.text = item.title
    listCell.cellMemo?.text = "メモ：" + item.memo

    if let data = item.img {
      let image: UIImage? = UIImage(data: data as Data)
      listCell.cellImg?.image = image
    }

    return listCell

  }
}
