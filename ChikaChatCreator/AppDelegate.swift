//
//  AppDelegate.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaSignIn
import FirebaseCommunity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if let uid = FirebaseCommunity.Auth.auth().currentUser?.uid, !uid.isEmpty {
            showChatCreator()
            
        } else {
            showSignIn()
        }
        
        return true
    }

}

func showSignIn() {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let window = delegate.window
    let scene = ChikaSignIn.Factory().withOutput({ result in
        switch result {
        case .ok(let ok):
            print("[ChikaSignIn]", ok)
            showChatCreator()
            
        case .err(let error):
            showAlert(withTitle: "Error", message: "\(error)", from: window!.rootViewController!)
        }
    }).build()
    scene.title = "Sign In"
    let nav = UINavigationController(rootViewController: scene)
    window?.rootViewController = nav
}

func showChatCreator() {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let window = delegate.window
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateInitialViewController()
    window?.rootViewController = vc
}

func showAlert(withTitle title: String, message: String, from parent: UIViewController) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        parent.present(alert, animated: true, completion: nil)
    }
}
