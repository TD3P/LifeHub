import Foundation
import RealmSwift

class DreamModel: Object {
  @objc dynamic var id: String = NSUUID().uuidString
  @objc dynamic var title = ""
  @objc dynamic var targetDate: Date? = nil
  @objc dynamic var createdDate: Date = Date()
  @objc dynamic var budget = 0
  @objc dynamic var url = ""
  @objc dynamic var memo = ""
  @objc dynamic var imgURL = ""
  @objc dynamic var img: NSData? = nil
  @objc dynamic var doneFlag = false
    

  override static func primaryKey() -> String? {
    return "id"
  }
}
