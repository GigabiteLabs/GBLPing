// File.swift
//
// Created by GigabiteLabs on 10/1/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Information, metrics, and data about a local device and it's
/// network connected interfaces.
public class GBLPingLocalDevice {
    /// An array of pointees, pointing at local IP interfaces,
    public var localIPInterfaces: [ifaddrs]? {
        var local: [ifaddrs] = []
        // Get list of all interfaces on the local device:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            local.append(ifptr.pointee)
        }
        return local
    }
    /// An array of Strings representing the names of all local IP interfaces.
    public var localIPInterfaceNames: [String]? {
        var localNames: [String] = []
        if let localIfs = localIPInterfaces {
            for interface in localIfs {
                localNames.append(String(cString: interface.ifa_name))
            }
            switch localNames.count > 0 {
            case true:
                return localNames
            case false:
                return nil
            }
        } else {
            return nil
        }
    }
    /// A tuple containing network data for the specified interface.
    public func networkInfoFor(localInterface: GBLPingNetworkInterface) ->
    (
            address: String,
            subnet: String,
            interface: GBLPingNetworkInterface
    )? {
        guard let interfaceNames = localIPInterfaceNames else { return nil }
        guard let interfaces = localIPInterfaces else { return nil }
        
        var returnTuple: ( address: String?, subnet: String?, interface: GBLPingNetworkInterface ) =
            ( address: nil, subnet: nil, interface: localInterface )
        
        for interface in interfaces {
            for name in interfaceNames {
                if  name == localInterface.rawValue {
                    // convert interface IP
                    // address to a human readable string
                    var addr = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &addr, socklen_t(addr.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    returnTuple.address = String(cString: addr)
                    
//                    let net = interface.ifa_netmask.pointee
//                    var subnetM = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_netmask, socklen_t(net.sa_len),
//                                &subnetM, socklen_t(addr.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
                    // convert interface subnet mask
                    // address to a human readable string
                    returnTuple.subnet = ""//String(cString: subnetM)
                }
            }
        }

        // ensure both values set or
        // return nil to indicate an error
        // occured.
        switch returnTuple.address != nil {// &&
            // returnTuple.subnet != nil {
        case true:
            return (address: returnTuple.address!, subnet: returnTuple.subnet!, interface: localInterface)
        case false:
            return nil
        }
    }
}
