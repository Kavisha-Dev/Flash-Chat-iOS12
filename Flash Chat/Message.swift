//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    
    //TODO: Messages need a messageBody and a sender variable
    
    var sender : String = "";
    
    var messageBody : String = "";
    
    init(email : String, content : String) {
        sender = email
        messageBody = content;
    }
    
    
    
}
