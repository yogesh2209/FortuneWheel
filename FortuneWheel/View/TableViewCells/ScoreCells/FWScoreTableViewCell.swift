//
//  FWScoreTableViewCell.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 12/5/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelWord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
