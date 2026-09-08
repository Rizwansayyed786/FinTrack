//
//  NavBar.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 05/09/26.
//

import SwiftUI
struct MainTabView: View {

    var body: some View {
        TabView {
            NavigationStack {
                AppContainer().makeHomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
            }
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }

            Text("Reports")
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Reports")
                }

            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

