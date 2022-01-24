//
//  ViewController.swift
//  Octopoll
//
//  Created by Dan on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import GBLPing
import XCTest

class ViewController: UIViewController {
    @IBOutlet weak var pingLog: UITextView!
    @IBOutlet weak var pingButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var reachabilityButton: UIButton!
    
    @IBAction func pingButtonAction(_ sender: Any) {
        Ping.svc.pingHostname(hostname: "ns.cloudflare.com", maxPings: 10, nil)
    }
    @IBAction func pauseButtonAction(_ sender: Any) {
        Ping.svc.stop()
        setButtonsForPause()
    }
    @IBAction func stopButtonAction(_ sender: Any) {
        Ping.svc.stop()
        setupDefaultUI()
    }
    @IBAction func reachabilityButtonAction(_ sender: Any) {
        reachabilityTesting = true
        pingLog.text = "checking reachability of ns.cloudflare.com ..\n"
        Ping.network.isReachable { result in
            print("network reachable?: \(result)")
        }
    }
    
    var reachabilityTesting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup UI
        setupDefaultUI()
        
        // Do any additional setup after loading the view.
        Ping.svc.delegate = self
        Ping.svc.eventDelegate = self
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
    
    func setDefaultButtons() {
        pingButton.isHidden = false
        pingButton.setTitle("Start Pinging", for: .normal)
        pauseButton.isHidden = true
        stopButton.isHidden = true
        reachabilityButton.isHidden = false
    }
    
    func setButtonsForPingStart(){
        pingButton.isHidden = true
        pauseButton.isHidden = false
        stopButton.isHidden = true
        reachabilityButton.isHidden = true
    }
    
    func setButtonsForPause() {
        pingButton.isHidden = false
        pingButton.setTitle("Resume Pinging", for: .normal)
        pauseButton.isHidden = true
        stopButton.isHidden = false
        reachabilityButton.isHidden = true
    }
    
    func setButtonsForReachability() {
        pingButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = false
        reachabilityButton.isHidden = true
    }
    

    func setupDefaultUI() {
        pingLog.text = "activity will appear here. the default ping location is cloudflare's main name server"
        setDefaultButtons()
    }
    
    func setDefaultVars() {
        reachabilityTesting = false
    }
    
    func setButtonsForReset() {
        setDefaultButtons()
    }
}

extension ViewController: GBLPingDelegate, GBLPingEventDelegate {
    func gblPingEvent(_ event: GBLPingEvent) {
        
        switch event {
        case .pingWillStart:
            if reachabilityTesting {
                setButtonsForReachability()
            } else {
                pingLog.text = "pinging ns.cloudflare.com ..\n"
                setButtonsForPingStart()
            }
        case .pingDidStop:
            print("ping event: \(event.description)")
            if reachabilityTesting {
                setDefaultButtons()
                setDefaultVars()
            }
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
