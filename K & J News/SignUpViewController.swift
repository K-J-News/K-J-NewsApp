//
//  SignUpViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/7/22.
//

import UIKit
import Parse
class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignUp(_ sender: Any) {
        
        // create parse user object
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        // custom attributes for our users
        user["lang"] = "en"
        user["country"] = "us"

          user.signUpInBackground {
              (success, error) -> Void in
                if success{
                    self.performSegue(withIdentifier: "signUpToFeedSegue", sender: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
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
