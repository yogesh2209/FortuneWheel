//
//  FWSpinningWheelViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/9/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import SpinWheelControl
import AVFoundation

protocol FWSpinningWheelViewControllerDelegate
{
    func saveSpin(spinString : String)
}

class FWSpinningWheelViewController: UIViewController, SpinWheelControlDataSource, SpinWheelControlDelegate, AVAudioPlayerDelegate {
    
    let spinLabelArray: [String] = ["$500","$900","$500","Bankrupt","$225","$500","$100","$300","$1000","$750","Bankrupt","$100000","Bankrupt","$2500","Bankrupt","$500","$1","$250","$1000","Bankrupt","$700"]
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var spinWheelControl: SpinWheelControl!
    @IBOutlet weak var labelSpinResult: UILabel!
    var delegate : FWSpinningWheelViewControllerDelegate?
    var timer = Timer()
  
    var player:AVAudioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        allocation()
       // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound(){
        do
        {
            let audioPath = Bundle.main.path(forResource: "sound", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch
        {
            //PROCESS ERROR
        }
        let session = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch
        {
        }
        player.delegate = self
        player.play()
    }
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playSound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLabels()
        toggleUserInterationSpinWheel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    //MARK: UIButton Action
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Private Methods
    func toggleUserInterationSpinWheel(isInterationEnabled : Bool = true) {
        if isInterationEnabled == true {
            self.spinWheelControl.isUserInteractionEnabled = true
        }
        else{
            self.spinWheelControl.isUserInteractionEnabled = false
        }
    }
    func allocation() {
        spinWheelControl.dataSource = self
        spinWheelControl.reloadData()
        spinWheelControl.delegate = self
        spinWheelControl.addTarget(self, action: #selector(spinWheelDidChangeValue), for: UIControlEvents.valueChanged)
        spinWheelControl.addTarget(self, action: #selector(spinWheelDidEdit), for: UIControlEvents.touchUpInside)
        
    }
    func hideLabels() {
        DispatchQueue.main.async {
            self.labelSpinResult.isHidden = true
        }
    }
    func showLabels(spinValue : String) {
        DispatchQueue.main.async {
            self.labelSpinResult.isHidden = false
            self.labelSpinResult.text = spinValue
            self.timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.popScreen), userInfo: nil, repeats: true)
        }
    }
    // must be internal or public.
    @objc func popScreen() {
        delegate?.saveSpin(spinString: loadPlistData()?[self.spinWheelControl.selectedIndex] as! String)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Private Methods
    func loadPlistData() -> NSMutableArray? {
        let spinLabelArray = NSMutableArray()
        if let URL = Bundle.main.url(forResource: "Spin", withExtension: "plist") {
            guard let labelFromPlist = NSDictionary(contentsOf: URL) else { return nil }
            if let tempSpinArray = labelFromPlist.value(forKey: "SpinLabel") as? [String] {
                for label in tempSpinArray {
                    spinLabelArray.add(label)
                }
            }
            return spinLabelArray
        }
        return nil
    }
    
    //MARK: SpinningWheel Datasource
    func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
        return 20
    }
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()
        wedge.shape.fillColor = UIColor.random().cgColor
        wedge.label.text = loadPlistData()?[Int(index)] as? String
        wedge.label.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        return wedge
    }
    
    //MARK: SpinningWheel Delegate
    @objc func spinWheelDidChangeValue(sender: AnyObject) {
       // player.stop()
        showLabels(spinValue: loadPlistData()?[self.spinWheelControl.selectedIndex] as! String)
    }
    
    //MARK: SpinningWheel Delegate
    @objc func spinWheelDidEdit(sender: AnyObject) {
       // playSound()
        toggleUserInterationSpinWheel(isInterationEnabled: false)
    }
    func spinWheelDidEndDecelerating(spinWheel: SpinWheelControl) {
      //  print("The spin wheel did end decelerating.")
    }
    
    func spinWheelDidRotateByRadians(radians: Radians) {
        toggleUserInterationSpinWheel(isInterationEnabled: false)
      //  print("The wheel did rotate this many radians - " + String(describing: radians))
    }
}

//MARK: Extensions
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
