//
//  FWAboutViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 12/5/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWAboutViewController: UIViewController {
    
    @IBOutlet weak var textViewAbout: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CustomiseUI
    func setTextView() {
        self.textViewAbout.text = "This application is developed as a final project for iOS development Class (Computer Science Department) which comes under Extended Studies - San Diego State University. This app aims to provide a seamless experience similar to Wheel of Fortune TV show."
    }
    
}
