//
//  FWNewGameViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/7/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWNewGameViewController: FWBaseClassViewController {
    
    @IBOutlet weak var barButtonMenu: UIBarButtonItem!
    
    @IBOutlet weak var buttonScores: FWCustomButton!
    @IBOutlet weak var buttonNewGame: FWCustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func buttonScoresPressed(_ sender: FWCustomButton) {
        self.performSegue(withIdentifier: POST_SCORE_SEGUE, sender: nil)
    }
    @IBAction func buttonNewGamePressed(_ sender: FWCustomButton) {
        self.performSegue(withIdentifier: POST_NEWGAME_SEGUE, sender: nil)
    }
}
