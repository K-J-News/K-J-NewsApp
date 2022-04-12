//
//  ProfileViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/9/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appear")
        let user = PFUser.current()!
        usernameOutlet.text = user.username
        countryOutlet.text = user["country"]! as! String
        langOutlet.text = user["lang"]! as! String
    }
    
    @IBOutlet weak var usernameOutlet: UILabel!
    @IBOutlet weak var countryOutlet: UILabel!
    @IBOutlet weak var langOutlet: UILabel!
    @IBAction func onEditProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profileToEditSegue", sender: nil)
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        PFUser.logOut()
        self.dismiss(animated: true, completion: nil)
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
