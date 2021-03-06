//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // Declare instance variables here
    
    var messageArray : [Message] = [Message]()
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var getKeyboardHeight = CGFloat(336.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        messageTableView.register(UINib(nibName: "DefaultMessageCell", bundle: nil), forCellReuseIdentifier: "defaultMessageCell")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
        configureTableView()
        
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            getKeyboardHeight = keyboardHeight
//            print("get keyboardHeight: \(getKeyboardHeight)")
        }
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email as String? {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultMessageCell", for: indexPath) as! DefaultMessageCell
            
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            cell.senderUsername.text = messageArray[indexPath.row].sender
            
            cell.avatarImageView.image = UIImage(named: "egg")
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
            
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            cell.senderUsername.text = messageArray[indexPath.row].sender
            
            cell.avatarImageView.image = UIImage(named: "egg")
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
            return cell
        }
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    //TODO: Declare configureTableView here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = self.getKeyboardHeight + 17
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        

        messageTextfield.endEditing(true)

        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Send successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = ""
            }
        }
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
//            print(text, sender)
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        }
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            
        print("logout successful!")
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            print("Error, there was a problem signing out.")
        }
        
        
    }
    


}
