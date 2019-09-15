

import UIKit

class MainListCell: UITableViewCell {
    

  @IBOutlet weak var cellTitle: UILabel!
  @IBOutlet weak var cellMemo: UILabel!
  @IBOutlet weak var cellImg: UIImageView!
  @IBOutlet weak var cellTargetDate: UILabel!
  @IBOutlet weak var cellBudget: UILabel!
  var cellDoneFlag = false

  
  override func awakeFromNib() {
        super.awakeFromNib()
        print("セルの呼び出し")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

