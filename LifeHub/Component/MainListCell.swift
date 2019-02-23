//
//  MainListCellTableViewCell.swift
//  LifeHub
//
//  Created by 三瓶士継 on 2019/02/23.
//  Copyright © 2019 TD3P. All rights reserved.
//

import UIKit

class MainListCell: UITableViewCell {
    

  @IBOutlet weak var cellTitle: UILabel!
  @IBOutlet weak var cellMemo: UILabel!

  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

