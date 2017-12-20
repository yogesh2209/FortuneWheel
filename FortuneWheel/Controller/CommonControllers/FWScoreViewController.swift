//
//  FWScoreViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 12/5/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import DateToolsSwift

class FWScoreViewController: FWBaseClassViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if getDataFromUserDefaults()?.count == 0{
            showMessageLabel()
        }
        else{
            clearMessageLabel()
            self.tableView.reloadData()
        }
    }
    
    //MARK: Private Methods
    func customiseUI() {
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
    }
    //MARK: Private Methods
    func showMessageLabel() {
        messageLabel.isHidden = false
        messageLabel = UILabel.init(frame: CGRect(x: 0, y: self.tableView.frame.size.height/2, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = "No record found!"
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.init(name: "Palatino-Italic", size: 20.0)
        messageLabel.sizeToFit()
        tableView.isHidden = false
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    func clearMessageLabel() {
        messageLabel.isHidden = true
        self.tableView.isHidden = false
    }
    func getDataFromUserDefaults() -> NSMutableArray? {
        let defaults = UserDefaults.standard
        if let storeData = defaults.object(forKey: "SCORE_DATA") as? NSMutableArray {
            return storeData
        }
        else{
            showMessageLabel()
        }
        return []
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2*(getDataFromUserDefaults()?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Profile Cell
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_SCORE_DATA_CUSTOM_CELL, for: indexPath as IndexPath) as! FWScoreTableViewCell
            
            if getDataFromUserDefaults()?.count != 0 {
                let tempArray = getDataFromUserDefaults()![indexPath.row/2] as! [String : String]
                if let date = tempArray["date"] {
                    let finalDate = Date.init(dateString: date, format: "MM/dd/yyyy HH:mm:ss")
                    cell.labelTime.text = finalDate.timeAgoSinceNow
                }
                if let word = tempArray["word"] {
                    cell.labelWord.text = word
                }
                if let score = tempArray["score"] {
                    cell.labelScore.text = score
                }
            }
            return cell
        }
            //spacing cell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_SCORE_SPACING_CUSTOM_CELL, for: indexPath as IndexPath) as! FWSpacingTableViewCell
            return cell
        }
    }
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //data cell
        if indexPath.row % 2 == 0 {
            return 97.0
        }
            //Spacing cell
        else{
            return 12.0
        }
    }
}
