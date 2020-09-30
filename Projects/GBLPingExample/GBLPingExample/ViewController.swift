//
//  ViewController.swift
//  Octopoll
//
//  Created by Dan on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import GBLPing

import UIKit
import GBLPing

class ViewController: UIViewController {
    @IBOutlet weak var pingLog: UITextView!
    @IBOutlet weak var pingButton: UIButton!
    @IBAction func pingButtonAction(_ sender: Any) {
        Ping.service.pingHostname(hostname: "gigabitelabs.com", maxPings: 10)
    }
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func stopButtonAction(_ sender: Any) {
        Ping.service.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Ping.service.delegate = self
        Ping.service.dataDelegate = self
    }
    
    func updateResultLabel(with result: String) {
        let updateStr = "\n\(result)"
        if var currentResultText = pingLog.text {
            currentResultText += updateStr
            pingLog.text = currentResultText
        } else {
            pingLog.text = result
        }
        pingLog.scrollRangeToVisible( _NSRange(location: pingLog.text.count - 1, length: 1) )
    }
    // Reverses visibility on both buttons
    func toggleButtonVisibility() {
        pingButton.isHidden.toggle()
        stopButton.isHidden.toggle()
    }
}

extension ViewController: GBLPingDelegate, GBLPingDataDelegate {
    func gblPingEvent(_ event: GBLPingEvent) {
        switch event {
        case .pingWillStart:
            pingLog.text = "pinging ns.cloudflare.com ..\n"
            toggleButtonVisibility()
        case .pingDidStop:
            pingLog.text = "ping stopped.\nactivity will appear here."
            toggleButtonVisibility()
            print("ping event: \(event.description)")
            return
        default:
            print("ignoring update for event type.")
        }
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

extension ViewController: UITextViewDelegate {
    // TODO add input handing on demo project
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
