//
//  EditProfileViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/11/22.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var langTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    @IBOutlet weak var langPickerView: UIPickerView!
    
    var countryPickerDisplayData: [String] = [String]()
    var countryPickerValueData: [String] = [String]()
    var langPickerDisplayData: [String] = [String]()
    var langPickerValueData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        langPickerView.delegate = self
        langPickerView.dataSource = self
        
        countryTextField.delegate = self
        langTextField.delegate = self
        
        
        countryPickerDisplayData = ["United Arab Emirates", "Argentina", "Austria", "Australia", "Belgium", "Bulgaria", "Brazil",  "Canada",  "Switzerland", "China", "Colombia", "Cuba", "Czech Republic", "Germany", "Egypt", "France", "United Kingdom", "Greece", "Hong Kong",  "Hungary", "Indonesia", "Ireland", "Israel", "India", "Italy", "Japan", "South Korea", "Lithuania", "Latvia", "Morocco", "Mexico", "Malaysia", "Nigeria", "Netherlands", "Norway", "New Zealand", "Philippines", "Poland", "Portugal", "Romania", "Serbia", "Russia", "Saudi Arabia",  "Sweden", "Singapore", "Slovenia", "Slovakia", "Thailand", "Turkey", "Taiwan", "Ukraine", "United States", "Venezuela", "South Africa"]
        countryPickerValueData = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it",  "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve",  "za",]
        
        langPickerDisplayData = [ "Arabic", "German", "English", "Spanish", "French", "Hebrew", "Italian", "Dutch", "Norwegien", "Portuguese", "Russian", "Swedish","Urdu" ,"Chinese"]
        langPickerValueData = ["ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "se","ud" ,"zh"]


        
        
        let user = PFUser.current()!
        
        let user_lang = user["lang"] as! String
        let user_country = user["country"] as! String
        
        usernameTextField.text = user.username
        usernameTextField.placeholder = "Enter a new username"

        countryTextField.text = user_country
        countryTextField.placeholder = "Enter a new country (use two character code)"
        
        passwordTextField.placeholder = "Enter a new password"
        
        langTextField.text = user_lang
        countryTextField.placeholder = "Enter a new langauge (use two character code)"
        
        countryTextField.inputView = countryPickerView
        countryTextField.inputAccessoryView = toolBar
        
        langTextField.inputView = langPickerView
        langTextField.inputAccessoryView = toolBar
        
        countryPickerView.isHidden = true
        langPickerView.isHidden = true
        messageLabel.isHidden = true
        
        
        if let indexPosition = countryPickerValueData.firstIndex(of: user_country){
            countryPickerView.selectRow(indexPosition, inComponent: 0, animated: true)
        }
        if let indexPosition = langPickerValueData.firstIndex(of: user_lang){
            langPickerView.selectRow(indexPosition, inComponent: 0, animated: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func donePicker(_ pickerView: UIPickerView,_ textField: UITextField) {
        countryTextField.resignFirstResponder()
        countryPickerView.isHidden = true
        langTextField.resignFirstResponder()
        langPickerView.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView{
                return countryPickerDisplayData.count
            } else {
                return langPickerDisplayData.count
            }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView{
                return "\(countryPickerDisplayData[row])"
            } else {
                return "\(langPickerDisplayData[row])"
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView{
                countryTextField.text = countryPickerValueData[row]
                //countryPickerView.isHidden = true
            } else {
                langTextField.text = langPickerValueData[row]
                //langPickerView.isHidden = true
            }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if textField == countryTextField{
            print("country is hidden false")
            countryPickerView.isHidden = false
            return true
        }
        else {
            print("lang is hidden false")
            langPickerView.isHidden = false
            return true
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let user = PFUser.current()!
        
        if passwordTextField.text?.count != 0{
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user["country"] = countryTextField.text
            user["lang"] = langTextField.text
            
            let alert = UIAlertController(title: "Save info?", message: "Do you want to save updated profile info?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Save",style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                user.saveInBackground(){ (succeeded, error)  in
                    if (succeeded) {
                        // The object has been saved.
                        self.messageLabel.isHidden = false
                        self.messageLabel.textColor = UIColor.green
                        self.messageLabel.text = "Changes saved successfully"
                    } else {
                        // There was a problem, check error.description
                        self.messageLabel.isHidden = false
                        self.messageLabel.textColor = UIColor.red
                        self.messageLabel.text = error?.localizedDescription
                        self.messageLabel.shake()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.messageLabel.isHidden = false
            self.messageLabel.textColor = UIColor.red
            self.messageLabel.text = "Please enter a password."
            self.messageLabel.shake()
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
