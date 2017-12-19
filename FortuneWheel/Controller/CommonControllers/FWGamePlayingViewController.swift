//
//  FWGamePlayingViewController.swift
//  FortuneWheel
//
//  Created by Yogesh Kohli on 11/13/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class FWGamePlayingViewController: FWBaseClassViewController, UITextFieldDelegate, FWSpinningWheelViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var buttonQuit: UIButton!
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelHeadingStatus: UILabel!
    @IBOutlet weak var viewEnterWord: UIView!
    @IBOutlet weak var textFieldWord: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var buyVowel: UIButton!
    @IBOutlet weak var buttonSpin: UIButton!
    @IBOutlet weak var labelWordCategory: UILabel!
    
    var isViewAppearFromPopUp = Bool() // to indicate that this screen has come from previous screen not after spin wheel
    var topicsAndWord:Dictionary<String,Array<String>>?
    var topicType:Array<String>?
    var selectedTopic:String?
    var words:Array<String>?
    var alphabetArray : Array<Any>?
    var binaryArray = NSMutableArray()
    var spinStringValue : String = ""
    var vowelArray = NSMutableArray()
    var timer = Timer()
    var wordToSend = String()
    var alphabetGuessedArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphabetGuessedArray.add("A")
        alphabetGuessedArray.add("E")
        alphabetGuessedArray.add("I")
        alphabetGuessedArray.add("O")
        alphabetGuessedArray.add("U")
        customiseUI()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if isViewAppearFromPopUp == false {
            isViewAppearFromPopUp = true
            loadPlistData()
            setCurrentScore()
            hideLabels()
            toggleWordAndSpinBtn()
            self.collectionView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    //MARK: UITextField Delegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = self.textFieldWord.text!
        for index in 0..<alphabetGuessedArray.count {
            let alphabet : String = alphabetGuessedArray[index] as! String
            if alphabet == string {
                return false
            }
        }
        if text.count < 1 || string == "" {
            return true
        }
        else{
            return false
        }
    }
    
    //MARK: Private Methods
    func loadPlistData() {
        let data:Bundle = Bundle.main
        let topicPlist:String? = data.path(forResource: "Data", ofType: "plist")
        if topicPlist != nil {
            topicsAndWord = (NSDictionary.init(contentsOfFile: topicPlist!) as! Dictionary)
            topicType = topicsAndWord?.keys.sorted()
            var randomNumber = Int(arc4random_uniform(UInt32(topicType!.count)))
            if randomNumber == topicType!.count {
                randomNumber = randomNumber - 1
            }
            selectedTopic = topicType![randomNumber]
            updateCategoryLabel(category: selectedTopic!)
            words = topicsAndWord![selectedTopic!]!
            randomNumber = Int(arc4random_uniform(UInt32(words!.count)))
            if randomNumber == topicType!.count {
                randomNumber = randomNumber - 1
            }
            if  randomNumber <= (words?.count)! {
                alphabetArray = Array(words![randomNumber])
                wordToSend = words![randomNumber]
                for index in 0..<alphabetArray!.count {
                    if String(describing: alphabetArray![index]) == "A" || String(describing: alphabetArray![index]) == "E" || String(describing: alphabetArray![index]) == "I" || String(describing: alphabetArray![index]) == "O" || String(describing: alphabetArray![index]) == "U" {
                        let alphabet = String(describing: alphabetArray![index])
                        if !vowelArray.contains(alphabet) {
                            vowelArray.add(alphabet)
                        }
                    }
                    
                    if String(describing: alphabetArray![index]) == " " {
                        binaryArray.add("1")
                    }
                    else{
                        binaryArray.add("0")
                    }
                }
                updateBuyVowelButton()
            }
        }
    }
    func toggleWordAndSpinBtn(isSpinButtonHidden : Bool = false) {
        if isSpinButtonHidden == false {
            DispatchQueue.main.async {
                self.buttonSpin.isHidden = false
                self.viewEnterWord.isHidden = true
                self.buttonGo.isHidden = true
            }
        }
        else{
            DispatchQueue.main.async {
                self.buttonSpin.isHidden = true
                self.viewEnterWord.isHidden = false
                self.buttonGo.isHidden = false
            }
        }
    }
    func toggleBuyVowelButton(isButtonHidden : Bool = false) {
        if isButtonHidden == false {
            DispatchQueue.main.async {
                self.buyVowel.isHidden = false
            }
        }
        else {
            DispatchQueue.main.async {
                self.buyVowel.isHidden = true
            }
        }
    }
    func updateAlphabetPressedArrayField(alphabet : String) {
        if alphabet != "" {
            alphabetGuessedArray.add(alphabet)
        }
    }
    func hideLabels() {
        DispatchQueue.main.async {
            self.labelHeadingStatus.isHidden = true
        }
    }
    func clearWordTextField() {
        DispatchQueue.main.async {
            self.textFieldWord.text = ""
        }
    }
    func showLabels(message : String = "") {
        DispatchQueue.main.async {
            self.labelHeadingStatus.isHidden = false
            self.labelHeadingStatus.text = message
        }
    }
    func updateCategoryLabel(category : String) {
        if category != "" {
            self.labelWordCategory.isHidden = false
            DispatchQueue.main.async {
                self.labelWordCategory.text = category
            }
        }
        else{
            self.labelWordCategory.isHidden = true
        }
    }
    func customiseUI() {
        textFieldWord.backgroundColor = UIColor.clear
        viewEnterWord.layer.cornerRadius = 10
        viewEnterWord.layer.masksToBounds = true
        buttonGo.layer.cornerRadius = 10
        buttonGo.layer.masksToBounds = true
    }
    func getTextFieldWord() -> String {
        if let alphabet = self.textFieldWord.text {
            return alphabet
        }
        else{
            return ""
        }
    }
    func storeScoreInUserDefaults(score: String) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: "HIGHSCORE")
    }
    func alertMessageForSpecialCase(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message:message, preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                //take him to previous screen
                self.navigationController?.popViewController(animated: true)
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func updateScoreLabelString(score : String) {
        self.labelPoints.text = score
        if let scoreInt = Int(score.replacingOccurrences(of: "$", with: "")) {
            if scoreInt > 0 {
                self.labelPoints.textColor = UIColor.green
            }
            else{
                self.labelPoints.textColor = UIColor.red
            }
        }
    }
    func getCurrentScore() -> String {
        if let score = self.labelPoints.text {
            return score
        }
        else{
            return ""
        }
    }
    func setCurrentScore(score : String = "") {
        if score != "" {
            DispatchQueue.main.async {
                self.labelPoints.text = "$\(score)"
            }
        }
        else{
            DispatchQueue.main.async {
                self.labelPoints.text = "$0"
            }
        }
    }
    func updateBuyVowelButton() {
        if vowelArray.count != 0 {
            if let currentScoreInt = Int(self.getCurrentScore().replacingOccurrences(of: "$", with: "")) {
                if currentScoreInt >= 500 {
                    toggleBuyVowelButton()
                }
                else{
                    toggleBuyVowelButton(isButtonHidden: true)
                }
            }
        }
        else{
            toggleBuyVowelButton(isButtonHidden: true)
        }
    }
    func buyVowelButtonAction() {
        if vowelArray.count != 0 {
            if let currentScoreInt = Int(self.getCurrentScore().replacingOccurrences(of: "$", with: "")) {
                if currentScoreInt >= 500 {
                    let randomNumber = Int(arc4random_uniform(UInt32(vowelArray.count)))
                    if countOccurenceAlphabetInWord(alphabet: vowelArray[randomNumber] as! String, wordArray: alphabetArray!) != 0 {
                        if countOccurenceAlphabetInWord(alphabet: vowelArray[randomNumber] as! String, wordArray: alphabetArray!) == 1 {
                            showLabels(message: "\(countOccurenceAlphabetInWord(alphabet: vowelArray[randomNumber] as! String, wordArray: alphabetArray!)) \(vowelArray[randomNumber] as! String)")
                        }
                        else{
                            showLabels(message: "\(countOccurenceAlphabetInWord(alphabet: vowelArray[randomNumber] as! String, wordArray: alphabetArray!)) \(vowelArray[randomNumber] as! String)'s")
                        }
                    }
                    updateScoreLabelString(score: self.manageScore(currentScore: self.getCurrentScore(), argument: "$500", noOfTimes: self.countOccurenceAlphabetInWord(alphabet: self.vowelArray[randomNumber] as! String, wordArray: self.alphabetArray!), method: "SUBTRACT", vowelBought: true))
                    clearWordTextField()
                    updateCollectionView(alphabet: vowelArray[randomNumber] as! String, wordArray: alphabetArray!)
                }
            }
        }
    }
    func countOccurenceAlphabetInWord(alphabet : String, wordArray : Array<Any>) -> Int {
        var count : Int = 0
        let tempWordArray: [String] = wordArray.flatMap { String(describing: $0) }
        for index in 0..<wordArray.count {
            if alphabet == tempWordArray[index] {
                count = count + 1
            }
        }
        return count
    }
    func manageScore(currentScore : String, argument: String, noOfTimes: Int = 1,  method: String, vowelBought: Bool = false) -> String {
        //Right Alphabet
        if method == "ADD" && vowelBought == false {
            if let currentScoreInt = Int(currentScore.replacingOccurrences(of: "$", with: "")) , let argumentInt = Int(argument.replacingOccurrences(of: "$", with: "")) {
                return "$\(currentScoreInt + argumentInt*noOfTimes)"
            }
            else if argument == "Bankrupt" {
                return "$0"
            }
            else{
                return currentScore
            }
        }
            //Alphabet not found
        else{
            if let currentScoreInt = Int(currentScore.replacingOccurrences(of: "$", with: "")) , let argumentInt = Int(argument.replacingOccurrences(of: "$", with: "")) {
                return "$\(currentScoreInt - argumentInt*noOfTimes)"
            }
            else if argument == "Bankrupt" {
                return "$0"
            }
            else{
                return currentScore
            }
        }
    }
    func updateCollectionView(alphabet : String, wordArray : Array<Any>) {
        let tempWordArray: [String] = wordArray.flatMap { String(describing: $0) }
        for index in 0..<tempWordArray.count {
            if alphabet == tempWordArray[index] {
                binaryArray[index] = "1"
            }
        }
        var tempVowelArray: [String] = vowelArray.flatMap { String(describing: $0) }
        for index in 0..<tempVowelArray.count {
            if tempVowelArray[index] == alphabet {
                vowelArray.removeObject(at: index)
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        toggleWordAndSpinBtn(isSpinButtonHidden: false)
        
        var count : Int = 0
        for var index in 0..<binaryArray.count {
            if String(describing: binaryArray[index]) == "0" {
                count = 1
                index = binaryArray.count + 1
            }
        }
        //All words have been guessed - now, it's time to wrap up this game
        if count == 0 {
            self.timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.pushScreen), userInfo: nil, repeats: true)
        }
    }
    // must be internal or public.
    @objc func pushScreen() {
        //Take him to finish game screen controller and pass his score to that screen and store his score into user defaults for high score view
        storeScoreInUserDefaults(score: self.getCurrentScore())
        self.performSegue(withIdentifier: POST_GAME_TO_SHARE_SEGUE, sender: nil)
    }
    func goButtonAction() {
        if textFieldWord.text?.count == 1 && alphabetArray?.count != 0 {
            if countOccurenceAlphabetInWord(alphabet: textFieldWord.text!, wordArray: alphabetArray!) != 0 {
                if countOccurenceAlphabetInWord(alphabet: textFieldWord.text!, wordArray: alphabetArray!) == 1 {
                    showLabels(message: "\(countOccurenceAlphabetInWord(alphabet: textFieldWord.text!, wordArray: alphabetArray!)) \(textFieldWord.text!)")
                }
                else{
                    showLabels(message: "\(countOccurenceAlphabetInWord(alphabet: textFieldWord.text!, wordArray: alphabetArray!)) \(textFieldWord.text!)'s")
                }
                updateScoreLabelString(score: self.manageScore(currentScore: self.getCurrentScore(), argument: self.spinStringValue, noOfTimes: self.countOccurenceAlphabetInWord(alphabet: self.textFieldWord.text!, wordArray: self.alphabetArray!), method: "ADD", vowelBought: false))
                updateAlphabetPressedArrayField(alphabet: self.textFieldWord.text!)
                clearWordTextField()
                updateCollectionView(alphabet: textFieldWord.text!, wordArray: alphabetArray!)
                updateBuyVowelButton()
            }
            else{
                //Not matched
                showLabels(message: "No \(textFieldWord.text!)")
                //Subtract this money from his score
                updateScoreLabelString(score: self.manageScore(currentScore: self.getCurrentScore(), argument: self.spinStringValue, noOfTimes: self.countOccurenceAlphabetInWord(alphabet: self.textFieldWord.text!, wordArray: self.alphabetArray!), method: "SUBTRACT", vowelBought: false))
                clearWordTextField()
                toggleWordAndSpinBtn(isSpinButtonHidden: false)
            }
        }
        else{
            self.alertMessage("Please enter one alphabet!")
        }
    }
    //MARK: UIButton Action
    @IBAction func buyVowelPressed(_ sender: UIButton) {
        buyVowelButtonAction()
    }
    @IBAction func buttonQuitPressed(_ sender: UIButton) {
        alertMessageForSpecialCase("Are you sure you want to quit ?")
    }
    @IBAction func buttonGoPressed(_ sender: UIButton) {
        goButtonAction()
    }
    @IBAction func buttonSpinPressed(_ sender: Any) {
        //present spinning screen and let me spin one time
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController =
            storyBoard.instantiateViewController(withIdentifier: POST_SPIN_WHEEL_STORYBOARD_ID) as! FWSpinningWheelViewController
        nextViewController.delegate = self
        self.present(nextViewController, animated:true, completion:nil)
    }
    //MARK: UIDelegate Method (Getting Data from the view controller back)
    func saveSpin(spinString : String) {
        spinStringValue = spinString
        toggleWordAndSpinBtn(isSpinButtonHidden: true)
    }
    
    //MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 160
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: POST_WORD_CUSTOM_CELL,
                                                      for: indexPath) as! FWWordCollectionViewCell
        if indexPath.row < 16  {
            cell.backgroundColor = UIColor.init(red: 0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.labelAlphabet.text = ""
        }
        else{
            if binaryArray.count == alphabetArray!.count && indexPath.row - 16 < binaryArray.count   {
                if binaryArray[indexPath.row - 16] as! String == "0" || binaryArray[indexPath.row - 16] as! String == "1" {
                    cell.labelAlphabet.text = "\(alphabetArray![indexPath.row - 16])"
                    if binaryArray[indexPath.row - 16] as! String  == "0" {
                        DispatchQueue.main.async {
                            cell.labelAlphabet.isHidden = true
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            cell.labelAlphabet.isHidden = false
                        }
                    }
                    
                    if cell.labelAlphabet.text == " " && binaryArray[indexPath.row - 16] as! String  == "1" {
                        cell.backgroundColor = UIColor.init(red: 0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    }
                    else{
                        cell.backgroundColor = UIColor.white
                    }
                }
                else{
                }
            }
            else{
                cell.backgroundColor = UIColor.init(red: 0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                cell.labelAlphabet.text = ""
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.bounds.size.width/16, height: self.view.bounds.size.width/16)
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: UINAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == POST_GAME_TO_SHARE_SEGUE) {
            // pass data to next screen
            let secondVC = segue.destination as! FWFinishGameViewController
            secondVC.word = wordToSend
        }
    }
}
