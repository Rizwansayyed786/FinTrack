//
//  KeychainStore.swift
//  FinTrack
//

import Foundation
import Security

/// Thin wrapper over the Keychain's generic-password class.
///
/// Credentials live here rather than in `UserDefaults`: a `UserDefaults` value
/// is an unprotected plist inside the app container and is trivially editable
/// on a jailbroken device, so it can't be trusted to answer "is this user
/// authenticated?".
struct KeychainStore {

    enum KeychainError: Error {
        case unexpectedStatus(OSStatus)
    }

    let service: String

    private func baseQuery(account: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    /// Writes `value`, replacing any existing entry for `account`.
    func save(_ value: String, account: String) throws {
        let data = Data(value.utf8)
        let query = baseQuery(account: account)

        let updateStatus = SecItemUpdate(
            query as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )

        if updateStatus == errSecSuccess { return }

        guard updateStatus == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(updateStatus)
        }

        var newItem = query
        newItem[kSecValueData as String] = data
        // Readable after the first unlock following a reboot, so a launch in the
        // background can still restore the session. Not synced to iCloud.
        newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let addStatus = SecItemAdd(newItem as CFDictionary, nil)

        guard addStatus == errSecSuccess else {
            throw KeychainError.unexpectedStatus(addStatus)
        }
    }

    /// Returns the stored value, or `nil` if there is no entry for `account`.
    func read(account: String) -> String? {
        var query = baseQuery(account: account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Removes the entry for `account`. Missing entries are not an error.
    func delete(account: String) {
        let status = SecItemDelete(baseQuery(account: account) as CFDictionary)

        assert(
            status == errSecSuccess || status == errSecItemNotFound,
            "Unexpected Keychain delete status: \(status)"
        )
    }
}
