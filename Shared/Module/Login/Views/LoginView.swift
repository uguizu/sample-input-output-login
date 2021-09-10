//
//  LoginView.swift
//  LoginSUISample (iOS)
//
//  Created by Eduardo Martinez on 8/5/21.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var goHome = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("User")
                    TextField("", text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    viewModel.emailValidation ? Color.gray : Color.red,
                                    lineWidth: 1
                                )
                                .padding(-4)
                        )
                        .padding(.bottom, 32)

                    Text("Password")
                    SecureField("", text: $viewModel.password)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    viewModel.passwordValidation ? Color.gray : Color.red,
                                    lineWidth: 1
                                )
                                .padding(-4)
                        )
                        .padding(.bottom, 32)

                    ProgressView("Please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .opacity(viewModel.isLoading ? 1 : 0)

                    Button("Log In") {
                        viewModel.didTapLogin.send()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 40, alignment: .center)
                    .disabled(!viewModel.isButtonEnabled)
                    .onReceive(viewModel.didLoginSucceed) {
                        goHome = true
                    }
                    .padding(.top, 24)
                }
                .padding()

                NavigationLink(
                    destination: Text("We are on home"),
                    isActive: $goHome,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
