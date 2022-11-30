//
//  AuthPresenter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 3.11.2022.
//

import Foundation

protocol AuthPresenter: AnyObject{
    var interactor: AuthInteractor? {get set}
    var view: AuthViewController? {get set}
    var router: AuthRouter? {get set}
    func createAccount(withEmail email: String?, password: String?) -> Void
    func logIn(email: String,password: String) -> Void
}

class AuthPresenterImpl: AuthPresenter{
    var interactor: AuthInteractor?
    var view: AuthViewController?
    var router: AuthRouter?
    
    func logIn(email: String,password: String) -> Void{
        interactor?.logIn(withEmail: email, password: password, { result in
            switch result{
            case .success:
                self.router?.navigateToHome()
            case .failure:
                // TODO: show message
                break
            }
        })
    }
    
    func createAccount(withEmail email: String?, password: String?) -> Void{
        guard let email = email, let password = password else {
            // .. TODO: SHOW ERROR MESSAGE
            return
        }

        interactor?.createAccount(withEmail: email, password: password, { result in
            switch result{
            case .success:
                print("presenter")
                self.router?.navigateToHome()
            case .failure:
                break
            }
        })
    }
    
}
