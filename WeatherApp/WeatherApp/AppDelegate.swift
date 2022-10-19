//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import FirebaseCore
import Swinject
import UIKit

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
        ])
        assembler?.apply(assembly: ViewControllerFactoryAssembly(assembler: assembler!))
        
    }

    /// - Initializing root
    private func initRoot() {
        let homeViewController = assembler?.resolver.resolve(HomeViewController.self)

        // let root = UINavigationController(rootViewController: homeViewController as! UIViewController)
        rootViewController = homeViewController as! HomeViewControllerImpl
    }
}
