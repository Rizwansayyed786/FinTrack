//
//  LoginView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 30/08/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel : LoginViewModel
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 24){
                VStack(spacing : 8){
                    Text("Welcome Back").font(.largeTitle).fontWeight(.bold)
                    Text("Login to continue to FinTrack!").foregroundStyle(.secondary)

                }
                
                VStack(spacing: 16){
                    TextField("Email", text: $viewModel.state.email)
                        .frame(maxWidth:.infinity)
                        .padding(16)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16)).keyboardType(.emailAddress)
                    SecureField("Password", text: $viewModel.state.password)
                        .frame(maxWidth:.infinity)
                        .padding(16)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                if let errorMessage = viewModel.state.errorMessage {
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                                    .font(.subheadline)
                            }
                Button {
                    Task {
                        await viewModel.login()
                    }
                } label: {
                    Group{
                        if viewModel.state.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }.frame(maxWidth:.infinity)
                }.padding(16).background(RoundedRectangle(cornerRadius: 16).fill(Color.blue)).foregroundStyle(Color.white).disabled(viewModel.state.isLoading)
            }.padding(16).frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .navigationDestination(isPresented: $viewModel.state.isLoggedIn){
                HomeView()
            }
        }
    }
}
