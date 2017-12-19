//
//  FWMenuProfileTableViewCell.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/6/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWMenuProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
