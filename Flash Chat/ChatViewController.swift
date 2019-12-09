//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var message : [Message] = [Message]();
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self;
        messageTableView.dataSource = self;
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self;
        
        
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped));
        messageTableView.addGestureRecognizer(tapGesture);
        
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell");
        
        self.configureTableView();
        self.retrieveMessages();
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell;
        
        cell.messageBody.text = message[indexPath.row].messageBody
        //"What if a very huge message is entered here and then do the lines get cut or do they remain as is"
            //message[indexPath.row].messageBody;
        cell.senderUsername.text = message[indexPath.row].sender;
        cell.avatarImageView.image = UIImage(named: "egg");
        cell.messageBackground.backgroundColor = UIColor.flatLime();
        return cell;
    }
    
    //Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count;
    }
    
    
    
    // Declare tableViewTapped here:
    @objc  func tableViewTapped() {
        messageTextfield.endEditing(true);
    }
    
    
    
    //Adjusts and repaints the table row as per the data size
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension;
        messageTableView.rowHeight = 120.0;
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308;
            self.view.layoutIfNeeded();
        }
    }
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50;
            self.view.layoutIfNeeded();
        }
    }
    
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        //Send the message to Firebase and save it in our database
        
        //close the keyboard area
        tableViewTapped();
        
        messageTextfield.isEnabled = false;
        sendButton.isEnabled = false;
        
        //create a message dictionary
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text];
        
        //save the data onto the database
        let messageDB = Database.database().reference().child("MessageDB");
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print("Error saving message data")
            } else {
                print("Message saved successfully!");
                
                self.messageTextfield.isEnabled = true;
                self.sendButton.isEnabled = true;
                
                self.messageTextfield.text = "";
                
            }
        }
    }
    
    //Create the retrieveMessages method here:
    func retrieveMessages() {
        print("********************** retrieve messages invoked *********************")
        
        let messageDB = Database.database().reference().child("MessageDB");
        
        messageDB.observe(DataEventType.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>;
            let sender = snapshotValue["Sender"]!;
            let messageBody = snapshotValue["MessageBody"]!;
            
            print(sender , messageBody);
            
            let msg : Message = Message(email: sender, content: messageBody)
            self.message.append(msg);
            
            print(msg);
            
            self.configureTableView();
            self.messageTableView.reloadData();
            print("********************** retrieve messages completed *********************")
            
            
        }
        
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        print("Log out pressed");
        
        //Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut();
            print("Signed out successfully")
        } catch {
            print("Logging out failed");
        }
        
        navigationController?.popToRootViewController(animated: true);
        
    }
    
}
