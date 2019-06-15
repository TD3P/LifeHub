import Foundation
import RealmSwift

class DreamModel: Object {
  @objc dynamic var id: String = NSUUID().uuidString
  @objc dynamic var title = ""
  @objc dynamic var targetDate = Date()
  @objc dynamic var expense = 0
  @objc dynamic var url = ""
  @objc dynamic var memo = ""
  @objc dynamic var imgURL = ""
  @objc dynamic var img: NSData? = nil

  override static func primaryKey() -> String? {
    return "id"
  }
}
