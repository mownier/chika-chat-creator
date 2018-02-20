//
//  ViewController.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaCore
import ChikaFirebase

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var scene: Scene!
    
    override func loadView() {
        super.loadView()
        
        let factory = Factory()
        scene = factory.onChatCreated({ [weak self] result in
            guard let this = self else {
                return
            }
            
            guard let vc = this.presentedViewController else {
                this.showResult(result)
                return
            }
            
            vc.dismiss(animated: true, completion: {
                this.showResult(result)
            })
            
        }).build()
        
        containerView.addSubview(scene.view)
        addChildViewController(scene)
        scene.didMove(toParentViewController: self)
    }
    
    override func viewDidLayoutSubviews() {
        guard scene != nil else {
            return
        }
        
        scene.view.frame = containerView.bounds
    }

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let switcher = OfflinePresenceSwitcher()
        let _ = switcher.switchToOffline { result in
            print("[ChikaFirebase/Writer:OfflinePresenceSwitcher]", result)
        }
        
        let action = SignOut()
        let operation = SignOutOperation()
        let _ = operation.withCompletion({ result in
            switch result {
            case .ok(let ok):
                print("[ChikaFirebase/Auth:SignOut]", ok)
                showSignIn()
                
            case .err(let error):
                showAlert(withTitle: "Error", message: "\(error)", from: self)
            }
            
        }).signOut(using: action)
    }
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        switch scene.create() {
        case .ok(let ok):
            showAlert(withTitle: "OK", message: "\(ok)", from: self)
        
        case .err(let error):
            showAlert(withTitle: "Error", message: "\(error)", from: self)
        }
    }
    
    func showResult(_ result: Result<Chat>) {
        switch result {
        case .ok(let chat):
            showAlert(withTitle: "Success", message: "\(chat)", from: self)
            
        case .err(let error):
            showAlert(withTitle: "Error", message: "\(error)", from: self)
        }
    }
    
}

