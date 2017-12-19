//
//  FWCustomButton.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/7/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWCustomButton: UIButton {

    required init?(coder SAButtonDecoder: NSCoder) {
        super.init(coder: SAButtonDecoder)
       // self.backgroundColor = UIColor.black
       // self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 15.0
       // self.layer.borderWidth = 3.0
       // self.setTitleColor(UIColor.white, for: .normal)
       // self.titleLabel?.font =  UIFont(name: "", size: 20)
        self.layer.masksToBounds = true
    }
}
