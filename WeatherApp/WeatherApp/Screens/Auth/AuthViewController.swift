//
//  AuthViewController.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 2.11.2022.
//

import UIKit

protocol AuthViewController: AnyObject {
    var presenter: AuthPresenter? { get set }
    func navigateToHome()
}

class AuthViewControllerImpl: UIViewController, AuthViewController, UITextFieldDelegate {
    var presenter: AuthPresenter?

    @IBOutlet var sigInView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var logInView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextFieldSign: UITextField!
    @IBOutlet weak var passwordTextFieldSign: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sigInView.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func didTapLogIn(_ sender: Any) {
        if ((emailTextField.text?.isEmpty) != nil) && ((passwordTextField.text?.isEmpty) != nil) {
            presenter?.logIn(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func didTapGoSignIn(_ sender: Any) {
        logInView.isHidden = true
        sigInView.isHidden = false
    }

    @IBAction func didTapCancel(_ sender: Any) {
        sigInView.isHidden = true
        logInView.isHidden = false
    }
    
    
    @IBAction func didTapSignIn(_ sender: Any) {
        presenter?.createAccount(withEmail: emailTextFieldSign.text, password: passwordTextFieldSign.text)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        titleLabel.layer.opacity = 0.0
        view.frame.origin.y = -200
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        titleLabel.layer.opacity = 1.0
        view.frame.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension UIViewController {
    func navigateToHome() {
        DispatchQueue.main.async {
            let homeVC = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}
