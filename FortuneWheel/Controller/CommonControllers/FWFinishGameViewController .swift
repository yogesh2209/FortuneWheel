//
//  FWFinishGameViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/28/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import SDWebImage

class FWFinishGameViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var viewScreenshot: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var labelWord: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    var word : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showImage()
        showScore()
        getWord()
        storeDatForScoreList(score: getStoredScore()!, word: self.word)
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK: UIButton Actions
    @IBAction func buttonCancelPressed(_ sender: Any) {
        //take him to home screen
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is FWNewGameViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    @IBAction func buttonSharePressed(_ sender: Any) {
        let activityItem: [AnyObject] = [self.saveScreenshot() as AnyObject]
        let activityVC = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
    }
    //MARK: Private Methods
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
    func getStoredScore() -> String? {
        let defaults = UserDefaults.standard
        if let filterDataStored = defaults.object(forKey: "HIGHSCORE") {
            return filterDataStored as? String
        }
        else{
            return nil
        }
    }
    func showImage() {
        if getStoredData() != nil {
            if let picture = getStoredData()!["image"] {
                self.imageViewProfilePic.layer.cornerRadius = self.imageViewProfilePic.frame.size.width/2
                self.imageViewProfilePic.clipsToBounds = true
                self.imageViewProfilePic.layer.borderColor = UIColor.darkGray.cgColor
                self.imageViewProfilePic.layer.borderWidth = 5.0
                self.imageViewProfilePic.layer.masksToBounds = true
                self.imageViewProfilePic.sd_setImage(with: URL(string: picture as! String), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }
    }
    func showScore() {
        if getStoredScore() != "" {
            if let score = getStoredScore() {
                DispatchQueue.main.async {
                    self.labelScore.text = score
                }
            }
        }
    }
    func saveScreenshot() -> UIImage {
        var image = UIImage()
        UIGraphicsBeginImageContextWithOptions(self.viewScreenshot.bounds.size, self.viewScreenshot.isOpaque, 0.0)
        self.viewScreenshot.drawHierarchy(in: self.viewScreenshot.bounds, afterScreenUpdates: false)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func getWord() {
        self.labelWord.text = self.word
        self.labelMessage.text = "Congratulations! Keep it up!"
    }
    func storeDatForScoreList(score : String, word : String) {
        let defaults = UserDefaults.standard
        if let storeData = defaults.object(forKey: "SCORE_DATA") as? NSMutableArray {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            let myString = formatter.string(from: Date())
            let yourDate = formatter.date(from: myString)
            let myStringafd = formatter.string(from: yourDate!)
            let dict = ["score":score, "word":word, "date":myStringafd]
            var tempArray = [] as NSMutableArray
            tempArray = storeData
            tempArray = NSMutableArray.init(array: storeData)
            tempArray.add(dict)
            defaults.setValue(tempArray, forKey: "SCORE_DATA")
            
        }
        else{
            //No score data already there, will have to insert it now into array and then into userdefaults
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            let myString = formatter.string(from: Date())
            let yourDate = formatter.date(from: myString)
            let myStringafd = formatter.string(from: yourDate!)
            let arrayToStore = [] as NSMutableArray
            let dict = ["score":score, "word":word, "date":myStringafd]
            arrayToStore.add(dict)
            defaults.setValue(arrayToStore, forKey: "SCORE_DATA")
        }
    }
}
