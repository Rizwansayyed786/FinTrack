//
//  AuthenticatedUser.swift
//  FinTrack
//

/// Result of a successful login: who signed in, plus the credential that proves
/// it. The token is kept off `User` deliberately — `User` describes a person,
/// not a session.
struct AuthenticatedUser {
    let user: User
    let token: String
}
