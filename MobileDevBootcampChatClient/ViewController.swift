//
//  ViewController.swift
//  MobileDevBootcampChatClient
//
//  Created by Pashley Clyde on 7/22/15.
//  Copyright (c) 2015 DeloitteDigital. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    lazy var socket:SocketIOClient = {
        let soc = SocketIOClient(socketURL: "ddbe-chat.eu-gb.mybluemix.net")
        
        soc.on("connect") {data, ack in
            
            self.sendMessage("joined the conversation")
            print("socket connected", terminator: "")
        }
        
        soc.on("package") {data, ack in
            
            
            if let package = data[0] as? [String:String] {
                
                var txt = "anonynous: "
                
                if let user = package["user"] {
                    txt = "\(user): "
                }
                
                if let message = package["message"] {
                    txt = txt + message
                }
                
                self.chatLabel.text = "\(self.chatLabel.text!)\n\(txt)"
            }
        }
        return soc
    }()
    
    //-----------------------------------------------------
    //MARK: - UIViewController Lifecycle
    //-----------------------------------------------------
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
        socket.connect()
    }
    
    //-----------------------------------------------------
    //MARK: - UITextFieldDelegate
    //-----------------------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage(textField.text!)
        inputTextField.text = ""
        return false
    }
    
    private func sendMessage(text:String) {
        let data = [
            "text": text,
            "name":"\(UIDevice.currentDevice().name)"
        ]
        socket.emit("message", data)
    }
}

