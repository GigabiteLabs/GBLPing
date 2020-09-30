// GBLPingTools.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

public enum GBLPingToolsNetworkInterface: String {
    // this will ONLY be valid for mobile phones
    // TODO: refactor based on device type
    case wifi = "en0"
}

public struct GBLPingTools {
    // initializable only by the
    // framework
    internal init() { }
    
    public func networkInfoFor(localInterface: GBLPingToolsNetworkInterface) ->
    (
            address: String,
            subnet: String,
            interface: GBLPingToolsNetworkInterface
    )? {
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // setup return tuple
        var returnTuple: (address: String?, subnet: String?, interface: GBLPingToolsNetworkInterface) =
            (address: nil, subnet: nil, interface: localInterface)
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == localInterface.rawValue {
                    // convert interface IP
                    // address to a human readable string
                    var addr = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &addr, socklen_t(addr.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    returnTuple.address = String(cString: addr)
                    let net = interface.ifa_netmask.pointee
                    var subnetM = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_netmask, socklen_t(net.sa_len),
                                &subnetM, socklen_t(addr.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    // convert interface subnet mask
                    // address to a human readable string
                    returnTuple.subnet = String(cString: subnetM)
                }
            }
        }
        freeifaddrs(ifaddr)
        // ensure both values set or
        // return nil to indicate an error
        // occured.
        switch returnTuple.address != nil &&
            returnTuple.subnet != nil {
        case true:
            return (address: returnTuple.address!, subnet: returnTuple.subnet!, interface: localInterface)
        case false:
            return nil
        }
    }
    
    public var localIPInterfaceNames: [String]? {
        var localInterfaces: [String] = []
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
                // Get interface name:
                let name = String(cString: interface.ifa_name)
                print("Interface name: \(name)")
                print("Interface name: \(name)")
                localInterfaces.append(name)
            }
        }
        switch localInterfaces.count > 0 {
        case true:
            return localInterfaces
        case false:
            return nil
        }
    }
}
