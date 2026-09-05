//
//  FinTrackApp.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 29/08/26.
//

import SwiftUI

@main
struct FinTrackApp: App {
    let container = AppContainer()
    var body: some Scene {
        WindowGroup {
            container.makeLoginView()
        }
    }
}
