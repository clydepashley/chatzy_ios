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
        let soc = SocketIOClient(socketURL: "mobiledevbootcampchat.mybluemix.net")
        
        soc.on("connect") {data, ack in
            soc.emit("chat message", "\(UIDevice.currentDevice().name) joined the conversation")
            println("socket connected")
        }
        
        soc.on("chat message") {data, ack in
            
            if let message = data?.firstObject as? String {
                self.chatLabel.text = "\(self.chatLabel.text!)\n\(message)"
                
            }
            
            /* Example code from Socket.io
            
                if let cur = data?[0] as? Double {
                    soc.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
                        soc.emit("update", ["amount": cur + 2.50])
                    }
                    ack?("Got your currentAmount", "dude")
                }
            */
        }

        return soc
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
        socket.connect()
    }
    
    @IBAction func sendMessage() {
        socket.emit("chat message", inputTextField.text)
        inputTextField.text = ""
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage()
        return false
    }
    
  
}

