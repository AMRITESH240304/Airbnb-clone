//
//  LoginSignUpView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 16/09/25.
//

import AuthenticationServices
import SwiftUI

struct LoginSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager:AuthManagerViewModel
    @State private var phoneNumber = ""
    @State private var countryCode = "+91"
    @State private var country = "India"

    var body: some View {
        ZStack {
            Theme.background

            VStack(spacing: 20) {

                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Text("Log in or sign up to Airbnb")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 10)

                Button(action: {

                }) {
                    HStack {
                        Text("Country/Region")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("\(country) (\(countryCode))")
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Phone number")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    TextField("\(countryCode)", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

                Text(
                    "We'll call or text you to confirm your number. Standard message and data rates apply."
                )
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)

                Button(action: {

                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)

                    Text("or")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)

                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal)

                SignInWithAppleButton(
                    .continue,
                    onRequest: { request in
                        request.requestedScopes = [.email, .fullName]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                                let userId = credential.user
                                let email = credential.email
                                let firstName = credential.fullName?.givenName
                                let lastName = credential.fullName?.familyName

                                let user = User(id: userId, email: email, firstName: firstName, lastName: lastName)
                                authManager.saveUser(user)

                                dismiss()
                            }
                        case .failure(let error):
                            print("Authentication error: \(error.localizedDescription)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 50)
                .padding(.horizontal)
                .cornerRadius(10)
                .signInWithAppleButtonStyle(.black)

                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    LoginSignUpView()
}
