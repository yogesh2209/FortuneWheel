//
//  FWSlideOutLeftMenuViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/6/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class FWSlideOutLeftMenuViewController: FWBaseClassViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let optionsArray = ["Home","About","Help"]
    var login_data : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private Methods
    func customiseUI() {
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    //Getting data from NSUserDefaults
    func getStoredData() -> [String : Any]? {
        let defaults = UserDefaults.standard
        if let filterDataStored = defaults.object(forKey: "LOGIN_DATA") {
            return filterDataStored as? [String : Any]
        }
        else{
            return nil
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonLogoutPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        self.performSegue(withIdentifier: POST_LOGOUT_SEGUE, sender: nil)
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 * optionsArray.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Profile Cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_MENU_PROFILE_CUSTOM_CELL, for: indexPath as IndexPath) as! FWMenuProfileTableViewCell
            
            cell.imageViewProfilePic.layer.cornerRadius = cell.imageViewProfilePic.frame.size.width/2
            cell.imageViewProfilePic.clipsToBounds = true
            cell.imageViewProfilePic.layer.borderColor = UIColor.darkGray.cgColor
            cell.imageViewProfilePic.layer.borderWidth = 5.0
            cell.imageViewProfilePic.layer.masksToBounds = true
            
            if getStoredData() != nil {
                if let firstName = self.getStoredData()!["first_name"] {
                    
                    if let lastName = self.getStoredData()!["last_name"] {
                        cell.labelName.text = "\(firstName) \(lastName)"
                    }
                    else{
                        cell.labelName.text = firstName as? String
                    }
                }
                if let picture = getStoredData()!["image"] {
                    cell.imageViewProfilePic.sd_setImage(with: URL(string: picture as! String), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            return cell
        }
            //Option cell
        else if indexPath.row % 2 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_MENU_OPTIONS_CUSTOM_CELL, for: indexPath as IndexPath) as! FWMenuOptionsTableViewCell
            cell.labelOptions.text = optionsArray[indexPath.row/2]
            return cell
        }
            //Spacing cell
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: POST_MENU_SPACING_CUSTOM_CELL, for: indexPath as IndexPath) as! FWMenuSpacingTableViewCell
            return cell
        }
    }
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Profile Cell
        if indexPath.row == 0 {
            return 186.0
        }
            //Option cell
        else if indexPath.row % 2 == 1 {
            return 60.0
        }
            //Spacing cell
        else{
            return 12.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 1 {
            //Home
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: POST_HOME_SEGUE_VC, sender: nil)
            }
                //About
            else if indexPath.row == 3 {
                self .performSegue(withIdentifier: POST_ABOUT_SEGUE, sender: nil)
            }
                //Help
            else if indexPath.row == 5 {
                self .performSegue(withIdentifier: POST_HELP_SEGUE, sender: nil)
            }
        }
    }
}
