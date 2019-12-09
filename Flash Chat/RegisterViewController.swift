//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth
import SVProgressHUD


class RegisterViewController: UIViewController {
    
    //Pre-linked IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
         SVProgressHUD.show();
        //Set up a new user on our Firbase database
        
        //Auth.auth().createUser(withEmail: emailTextfield, password: passwordTextfield, completion: )
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            if error != nil {
                print("Error courred", error.unsafelyUnwrapped);
                SVProgressHUD.dismiss();
            } else {
                print("Registration complete");
                
                SVProgressHUD.dismiss();
                
                self.performSegue(withIdentifier: "goToChat", sender: self);
            }
        }
  
    } 
    
    
}
