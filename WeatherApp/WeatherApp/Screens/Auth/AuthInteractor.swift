//
//  AuthInteractor.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 3.11.2022.
//

import Foundation
import FirebaseAuth

protocol AuthInteractor: AnyObject {
    var service: AuthService? { get set }
    func logIn(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void)
    func createAccount(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void)
}

class AuthInteractorImpl: AuthInteractor {
    var service: AuthService?

    func logIn(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void) {
        service?.logIn(withEmail: email, password: password, { result in
            switch result {
            case .success:
                completionHandler(.success(true))
            case .failure:
                completionHandler(.failure(.logInError))
            }
        })
    }

    func createAccount(withEmail email: String, password: String, _ completionHandler: @escaping (Result<Any, AuthError>) -> Void) {
        service?.createAccount(withEmail: email, password: password, { result in
            switch result {
            case .success:
                completionHandler(.success(true))
            case .failure:
                completionHandler(.failure(.creatError))
            }
        })
    }
}
