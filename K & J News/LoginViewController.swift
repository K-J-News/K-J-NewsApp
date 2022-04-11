//
//  LoginViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/7/22.
//

import UIKit
import Parse

//error message shake
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToFeedSegue", sender: nil)
        }
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground:username, password:password) {
          (user,error) -> Void in
          if user != nil {
              self.errorMessageLabel.isHidden = true
              UserDefaults.standard.set(true, forKey: "userLoggedIn")
              self.performSegue(withIdentifier: "loginToFeedSegue", sender: nil)
          } else {
            // The login failed. Check error to see why.
              print("Error: \(String(describing: error!.localizedDescription))")
              self.errorMessageLabel.isHidden = false
              self.errorMessageLabel.text = String(describing: error!.localizedDescription)
              self.errorMessageLabel.shake()
          }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToSignUpSegue", sender: nil)
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
