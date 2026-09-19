//
//  AuthSession.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 04/09/26.
//

import Foundation

/// App-wide authentication state, backed by the Keychain.
///
/// This is the single source of truth for "is the user signed in". It restores
/// the token on `init`, which is what lets `RootView` show `MainTabView`
/// directly on a cold launch instead of the login screen.
@Observable
final class AuthSession {

    private static let tokenAccount = "auth.token"

    private let store: KeychainStore

    private(set) var token: String?

    var isAuthenticated: Bool { token != nil }

    init(store: KeychainStore) {
        self.store = store
        self.token = store.read(account: Self.tokenAccount)
    }

    func login(token: String) {
        do {
            try store.save(token, account: Self.tokenAccount)
            self.token = token
        } catch {
            // Persisting failed, so don't claim a session we can't restore.
            print("AuthSession: failed to persist token — \(error)")
            self.token = nil
        }
    }

    func logout() {
        store.delete(account: Self.tokenAccount)
        token = nil
    }
}
