//
//  AuthService.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 3.11.2022.
//

import FirebaseAuth
import Foundation

protocol AuthService: AnyObject {
    func logIn(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void)
    func createAccount(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void)
}

class AuthServiceImpl: AuthService {
    func logIn(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                dlog(self, "SigIn Error: \(error.localizedDescription)")
                completionHandler(.failure(self.getAuthError(errCode: error._code)))
            } else {
                completionHandler(.success(true))
            }
        }
    }

    func createAccount(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in

            if let error = error {
                completionHandler(.failure(self.getAuthError(errCode: error._code)))
                dlog(self, "\(error)")
            } else {
                completionHandler(.success(true))
            }
        }
    }

    private func getAuthError(errCode: Int) -> AuthError {
        let error = AuthErrorCode.Code(rawValue: errCode)
        switch error {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        default:
            return .unKnownError
        }
    }
}
