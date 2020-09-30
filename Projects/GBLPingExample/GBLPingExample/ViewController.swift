//
//  ViewController.swift
//  Octopoll
//
//  Created by Dan on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import GBLPing

class ViewController: UIViewController {
    var pinger: SimplePing?
    var running = false
    var sendTimer: Timer?
    var hostName: String {
        if let input = ipInput.text, !input.isEmpty {
            return input
        }
        return "apple.com"
    }
    
    @IBOutlet weak var macLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var pingResultsLabel: UILabel!
    @IBOutlet weak var ipInput: UITextField!
    @IBOutlet weak var pingButton: UIButton!
    @IBAction func refreshIPButton(_ sender: Any) {
        self.updateIPLabel()
    }
    @IBAction func pingButton(_ sender: Any) {
        switch self.running {
        case true:
            self.pingButton.setTitle("Start", for: .normal)
            self.pingButton.tintColor = UIColor.blue
            GBLPing.service.stop()
            self.running = false
        case false:
            print("pinging: \(self.hostName)")
            GBLPing.service.pingHostname(hostname: hostName)
            self.pingButton.setTitle("Stop", for: .normal)
            self.pingButton.tintColor = UIColor.red
            self.pingResultsLabel.text = ""
            self.running = true
        }
        //self.pingResultsLabel.text = "test\n\(self.pingResultsLabel.text!)"
    }
    
    func updateIPLabel(){
        if let networkInfo = GBLPing.tools.networkInfoFor(localInterface: .wifi) {
            self.ipLabel.text = "IP: \(networkInfo.address), Subnet: \(networkInfo.subnet)"
        }else{
            self.ipLabel.text = "(unable to retrieve interface data)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateIPLabel()
        self.ipInput.delegate = self
        setupDelegates()
        // Tools
        print("local interface names: \(GBLPing.tools.localIPInterfaceNames ?? ["nil"])")
    }
    
    func setupDelegates() {
        GBLPing.service.delegate = self
        GBLPing.service.dataDelegate = self
    }
    
    func updateResultLabel(with result: String) {
        let updateStr = "\n\(result)"
        if var currentResultText = pingResultsLabel.text {
            currentResultText += updateStr
            pingResultsLabel.text = currentResultText
        } else {
            pingResultsLabel.text = result
        }
    }
}

extension ViewController: GBLPingDelegate, GBLPingDataDelegate {
    
    func gblPingEvent(_ event: GBLPingEvent) {
        print("ping event: \(event.description)")
        updateResultLabel(with: event.description)
    }
    
    func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
        print("ping unexpected event: \(event.description)")
        updateResultLabel(with: "unexpected event: \(event.description)")
    }
    
    func gblPingResult(result: GBLPingResult) {
        print("ping result: \(result.toJSONString())")
        updateResultLabel(with: result.toJSONString(options: .prettyPrinted))
    }
    
    func gblPingError(_ error: GBLPingUnexpectedEvent) {
        print("ping error: \(error.description)")
        updateResultLabel(with: "error: \(error.description)")
    }
}

extension ViewController: UITextFieldDelegate {
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        self.hostName = textField.text ?? ""
    //        self.ipInput.resignFirstResponder()
    //        return true
    //    }
    //
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        self.hostName = textField.text ?? ""
    //        return true
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    //        self.hostName = textField.text ?? ""
    //    }
}
