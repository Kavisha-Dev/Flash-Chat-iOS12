//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import FirebaseAuth
import SVProgressHUD


class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show();
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (authresult, error) in
            if error != nil {
                print("Error ocurred while logging in ");
                 SVProgressHUD.dismiss();
            } else {
                print("User \(authresult!.user.email!) logged in successfully.")
                
                SVProgressHUD.dismiss();
                
                self.performSegue(withIdentifier: "goToChat", sender: self);
            }
        }
 
    }

}  
