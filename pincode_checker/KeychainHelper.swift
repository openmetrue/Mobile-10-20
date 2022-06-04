//
//  KeychainHelper.swift
//  pincode_checker
//
//  Created by Mark Khmelnitskii on 04.06.2022.
//

import Foundation

final class KeychainHelper {
    func save(_ data: Data, service: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String) {
        let query = [
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        SecItemDelete(query)
    }
}
