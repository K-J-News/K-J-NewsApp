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
        
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        langPickerView.delegate = self
        langPickerView.dataSource = self
        
        countryTextField.delegate = self
        langTextField.delegate = self
        
        // langauges
        //ar = arabic
        //de = german
        //en = english
        //es = espanol
        //fr = french
        //he = hebrew
        //it = italian
        //nl = dutch
        //no = norwegien
        //pt = portuguse
        //ru = russian
        //se = swedish
        //ud = urdu
        //zh = chinese
        
        
        countryPickerDisplayData = ["Country 1", "Country 2", "Country 3", "Country 4", "Country 5", "Country 6"]
        countryPickerValueData = ["Country 1", "Country 2", "Country 3", "Country 4", "Country 5", "Country 6"]
        
        langPickerDisplayData = ["English", "Lang 2", "Lang 3", "Lang 4", "Lang 5", "Lang 6"]
        langPickerValueData = ["en", "Lang 2", "Lang 3", "Lang 4", "Lang 5", "Lang 6"]
        
        
        let user = PFUser.current()!
        usernameTextField.text = user.username
        usernameTextField.placeholder = "Enter a new username"
        
        countryTextField.text = user["country"] as! String
        countryTextField.placeholder = "Enter a new country (use two character code)"
        
        passwordTextField.placeholder = "Enter a new password"
        
        langTextField.text = user["lang"] as! String
        countryTextField.placeholder = "Enter a new langauge (use two character code)"
        
        countryTextField.inputView = countryPickerView
        langTextField.inputView = langPickerView
        
        countryPickerView.isHidden = true
        langPickerView.isHidden = true
        
        
        // Do any additional setup after loading the view.
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
                countryPickerView.isHidden = true
            } else {
                langTextField.text = langPickerValueData[row]
                langPickerView.isHidden = true
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
