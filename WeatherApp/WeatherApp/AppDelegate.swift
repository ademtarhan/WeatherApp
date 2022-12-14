//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import FirebaseCore
import Swinject
import UIKit
import FirebaseAuth
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var assembler: Assembler?
    var window: UIWindow?
    var rootViewController: UIViewController? {
        get { window?.rootViewController }
        set {
            window?.rootViewController = newValue
            window?.makeKeyAndVisible()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        initWindow()
        initDI()
        initRoot()
        

        return true
    }

    /// - Initializing window
    private func initWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func initDI() {
        assembler = Assembler([
            /// sceens
            HomeAssembly(),
            AuthAssembly(),
            EventAssembly(),
            EditAssembly(),
        ])
        assembler?.apply(assembly: ViewControllerFactoryAssembly(assembler: assembler!))
    }

    /// - Initializing root
    private func initRoot() {
        let homeViewController = assembler?.resolver.resolve(HomeViewController.self)
        let authController = assembler?.resolver.resolve(AuthViewController.self)
        let eventViewController = assembler?.resolver.resolve(EventViewController.self)
        // let root = UINavigationController(rootViewController: homeViewController as! UIViewController)
        if Auth.auth().currentUser != nil {
            rootViewController = UINavigationController(rootViewController: homeViewController as! HomeViewControllerImpl)
        }else{
            rootViewController = UINavigationController(rootViewController: authController as! AuthViewControllerImpl)
        }
        
    }
}
