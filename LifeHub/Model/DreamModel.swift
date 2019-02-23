import Foundation
import RealmSwift

class DreamModel: Object {
  @objc dynamic var title = "ホゲホゲ"
  @objc dynamic var targetDate = Date()
  @objc dynamic var expense = 0
  @objc dynamic var url = ""
  @objc dynamic var memo = "フガフガ"
  @objc dynamic var imgURL = ""


}
