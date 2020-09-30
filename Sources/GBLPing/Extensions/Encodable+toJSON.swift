// Encodable+toJSON.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Extension to encode generic types
extension Encodable {
    /// Attempts to encode `T` as `Data?` using `JSONDecoder`.
    ///
    /// - Precondition: `T` conforms to `Encodable`
    ///
    /// - Parameters:
    ///     - type: an object of type `T` where `T` conforms to `Encodable`
    ///
    /// - Returns: `Data?` or `nil`
    ///
    internal static func encode<T>(_ type: T ) -> Data? where T: Encodable {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(type)
            return encoded
        } catch {
            return nil
        }
    }
    /// Convenience function to return a JSON string
    /// representation of the object with optional output formattiong options/
    ///
    /// - Parameters:
    ///     - options: a output option of type `JSONEncoder.OutputFormatting`
    ///
    ///  - Returns: `String`, representing the encoded object as JSON.
    ///
    public func toJSONString(options: JSONEncoder.OutputFormatting?) -> String {
        do {
            let encoder = JSONEncoder()
            if let options = options {
                encoder.outputFormatting = options
            }
            let converted = try encoder.encode(self)
            guard let jsonString = String(data: converted, encoding: .utf8) else {
                return ""
            }
            return jsonString
        } catch {
            print("error: \(error)")
            return ""
        }
    }
    /// Convenience function to return a JSON string representation of the object.
    ///
    ///  - Returns: `String`, representing the encoded object as JSON.
    ///
    public func toJSONString() -> String {
        do {
            let encoder = JSONEncoder()
            let converted = try encoder.encode(self)
            guard let jsonString = String(data: converted, encoding: .utf8) else {
                return ""
            }
            return jsonString
        } catch {
            print("error: \(error)")
            return ""
        }
    }
}
