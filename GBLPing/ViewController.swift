//
//  ViewController.swift
//  Octopoll
//
//  Created by Dan on 2/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    var pinger: SimplePing?
    var sendTimer: Timer?
    var hostName = "www.apple.com"
    
    @IBOutlet weak var macLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var pingResultsLabel: UILabel!
    @IBOutlet weak var ipInput: UITextField!
    @IBOutlet weak var pingButton: UIButton!
    
    @IBAction func refreshIPButton(_ sender: Any) {
        self.updateIPLabel()
    }
    
    var running = false
    @IBAction func pingButton(_ sender: Any) {
        switch self.running{
        case true:
            self.pingButton.setTitle("Start", for: .normal)
            self.pingButton.tintColor = UIColor.blue
            self.stop()
            self.running = false
        case false:
            print("pinging: \(self.hostName)")
            self.start(forceIPv4: true, forceIPv6: false, hostname: self.hostName)
            if let mac = MacFinder.ip2mac(self.hostName){
                print("MAC address for target \(self.hostName): \(mac)")
                self.macLabel.text = "Target device MAC: \(mac)"
            }else{
                print("could not find a MAC address for target \(self.hostName)")
                self.macLabel.text = "no MAC found for \(self.hostName)"
            }
            self.pingButton.setTitle("Stop", for: .normal)
            self.pingButton.tintColor = UIColor.red
            self.pingResultsLabel.text = ""
            self.running = true
        }
        //self.pingResultsLabel.text = "test\n\(self.pingResultsLabel.text!)"
    }
    
    func updateIPLabel(){
        if let ip = self.getWiFiAddress(){
            self.ipLabel.text = ip
        }else{
            self.ipLabel.text = "(not on wifi)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateIPLabel()
        self.ipInput.delegate = self
    }

    
    func getWiFiAddress() -> String? {
        var address : String?
        var subnet: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    
                    address = String(cString: hostname)
                    
                    let net = interface.ifa_netmask.pointee
                    var subnetMask = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_netmask, socklen_t(net.sa_len),
                                &subnetMask, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    
                    subnet = String(cString: subnetMask)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return "IP: \(address!)\nSubnet: \(subnet!)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hostName = textField.text ?? ""
        self.ipInput.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.hostName = textField.text ?? ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.hostName = textField.text ?? ""
    }
}

extension ViewController: SimplePingDelegate {
    
    /// Called by the table view selection delegate callback to start the ping.
    
    func start(forceIPv4: Bool, forceIPv6: Bool, hostname: String) {
        self.pingerWillStart()
        
        NSLog("start")
        
        let pinger = SimplePing(hostName: hostName)
        self.pinger = pinger
        
        // By default we use the first IP address we get back from host resolution (.Any)
        // but these flags let the user override that.
        
        if (forceIPv4 && !forceIPv6) {
            pinger.addressStyle = .icmPv4
        } else if (forceIPv6 && !forceIPv4) {
            pinger.addressStyle = .icmPv6
        }
        
        pinger.delegate = self
        pinger.start()
    }
    
    /// Called by the table view selection delegate callback to stop the ping.
    
    func stop() {
        NSLog("stop")
        self.pinger?.stop()
        self.pinger = nil
        
        self.sendTimer?.invalidate()
        self.sendTimer = nil
        
        self.pingerDidStop()
    }
    
    /// Sends a ping.
    ///
    /// Called to send a ping, both directly (as soon as the SimplePing object starts up) and
    /// via a timer (to continue sending pings periodically).
    
    @objc func sendPing() {
        self.pinger!.send(with: nil)
    }
    
    // MARK: pinger delegate callback
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        NSLog("pinging %@", self.displayAddressForAddress(address: address as NSData))
        let stringRep = self.displayAddressForAddress(address: address as NSData)
        print(stringRep)
        self.pingResultsLabel.text = "\(stringRep)\n\(self.pingResultsLabel.text!)"
        // Send the first ping straight away.
        
        self.sendPing()
        
        // And start a timer to send the subsequent pings.
        
        assert(self.sendTimer == nil)
        self.sendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.sendPing), userInfo: nil, repeats: true)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        
        NSLog("failed: %@", self.shortErrorFromError(error: error as NSError))
        self.pingResultsLabel.text = "failed: \(self.shortErrorFromError(error: error as NSError))\(self.pingResultsLabel.text!)"
        self.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        NSLog("#%u sent", sequenceNumber)
        self.pingResultsLabel.text = "#\(sequenceNumber) sent\n\(self.pingResultsLabel.text!)"
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        NSLog("#%u send failed: %@", sequenceNumber, self.shortErrorFromError(error: error as NSError))
        self.pingResultsLabel.text = "#\(sequenceNumber) send failed\n\(self.pingResultsLabel.text!)"
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        NSLog("#%u received, size=%zu", sequenceNumber, packet.count)
        self.pingResultsLabel.text = "#\(sequenceNumber) recieved, size:\(packet.count)\n\(self.pingResultsLabel.text!)"
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        NSLog("unexpected packet, size=%zu", packet.count)
        self.pingResultsLabel.text = "unexpected packet, size:\(packet.count)\n\(self.pingResultsLabel.text!)"
    }
    
    // MARK: utilities
    
    /// Returns the string representation of the supplied address.
    ///
    /// - parameter address: Contains a `(struct sockaddr)` with the address to render.
    ///
    /// - returns: A string representation of that address.
    
    func displayAddressForAddress(address: NSData) -> String {
        var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))
        
        let success = getnameinfo(
            address.bytes.assumingMemoryBound(to: sockaddr.self),
            socklen_t(address.length),
            &hostStr,
            socklen_t(hostStr.count),
            nil,
            0,
            NI_NUMERICHOST
            ) == 0
        let result: String
        if success {
            result = String(cString: hostStr)
        } else {
            result = "?"
        }
        return result
    }
    
    /// Returns a short error string for the supplied error.
    ///
    /// - parameter error: The error to render.
    ///
    /// - returns: A short string representing that error.
    
    func shortErrorFromError(error: NSError) -> String {
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.cfHostErrorUnknown.rawValue) {
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey as String] {
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let f = gai_strerror(Int32(failureNum.intValue))
                        if f != nil {
                            return String(cString: f!)
                        }
                    }
                }
            }
        }
        if let result = error.localizedFailureReason {
            return result
        }
        return error.localizedDescription
    }
    
    func pingerWillStart() {
        self.pingResultsLabel.text = "\(self.pingResultsLabel.text!)\nStarting.."
    }
    
    func pingerDidStop() {
        self.pingResultsLabel.text = "\(self.pingResultsLabel.text!)\nStopping."
    }
}
