//
//  GBLPingEventDelegate.swift
//  
//
//  Created by Dan on 1/21/22.
//

import Foundation

/// Conforming objects will recieve service event data, but will also
/// maintain a local refernce to the GBLPing shared instance
public protocol GBLPingEventDelegate: GBLPingDelegate {
    /// Called whenever a `GBLPingService` event occurs.
    ///
    /// - Parameters:
    ///     - event: a `GBLPingEvent` object representing the
    ///     type of ping operation event that occured
    ///
    func gblPingEvent(_ event: GBLPingEvent)
}
