//
//  FWMainViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/6/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import SideMenu
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class FWMainViewController: FWBaseClassViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var buttonGoogleSignIn: UIButton!
    @IBOutlet weak var buttonFacebookLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private Methods
    func customiseUI() {
        buttonFacebookLogin.layer.cornerRadius = 5.0
        buttonFacebookLogin.layer.masksToBounds = true
        buttonGoogleSignIn.layer.cornerRadius = 5.0
        buttonGoogleSignIn.layer.masksToBounds = true
    }
    //MARK: UIButton Actions
    @IBAction func buttonGoogleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func buttonFacebookLoginPressed(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //   fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), gender,birthday,email"]).start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                }
                else
                {
                    let data:[String : Any] = result as! [String : Any]
                    var tempData : [String : Any] = [:]
                    tempData["first_name"] = data["first_name"]
                    tempData["last_name"] = data["last_name"]
                    if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, case let url = data["url"] as? String {
                        tempData["image"] = url
                    }
                    else {
                        tempData["image"] = ""
                    }
                    self.storeDataInUserDefaults(param: tempData)
                    self.performSegue(withIdentifier: POST_MAIN_TO_NEW_GAME_SEGUE, sender: nil)
                }
            })
        }
    }
    //Storing data in NSUserDefaults
    func storeDataInUserDefaults(param : [String : Any]) {
        let defaults = UserDefaults.standard
        defaults.set(param, forKey: "LOGIN_DATA")
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let imageUrl = user.profile.imageURL(withDimension: 200) as NSURL
            let imageUrlFinalString  = imageUrl.absoluteString!
            var data:[String : Any] = [ : ]
            let fullNameArr = user.profile.name.components(separatedBy: " ")
            data["first_name"] = fullNameArr[0]
            data["last_name"] = fullNameArr[1]
            data["image"] = imageUrlFinalString
            self.storeDataInUserDefaults(param: data)
            self.performSegue(withIdentifier: POST_MAIN_TO_NEW_GAME_SEGUE, sender: nil)
        } else {
        }
    }
}
