//
//  LoginState.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//


import Foundation

struct LoginState {
    var email : String = ""
    var password : String = ""
    var isLoading : Bool = false
    var isLoggedIn : Bool = false
    var errorMessage : String?
}


