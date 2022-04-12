//
//  EditProfileViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/11/22.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {

    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var langTextField: UITextField!
    

    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()!
        usernameTextField.text = user.username
        usernameTextField.placeholder = "Enter a new username"
        
        countryTextField.text = user["country"] as! String
        countryTextField.placeholder = "Enter a new country (use two character code)"
        
        passwordTextField.placeholder = "Enter a new password"
        
        langTextField.text = user["lang"] as! String
        countryTextField.placeholder = "Enter a new langauge (use two character code)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let user = PFUser.current()!
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user["country"] = countryTextField.text
        user["lang"] = langTextField.text
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
