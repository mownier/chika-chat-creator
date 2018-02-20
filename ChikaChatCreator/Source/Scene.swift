//
//  Scene.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaUI
import ChikaCore
import ChikaContactList

public final class Scene: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var onChatCreated: ((Result<Chat>) -> Void)!
    
    var chatCreator: (() -> ChatCreator)!
    var chatCreatorOperator: ChatCreatorOperator!
    
    var contactQuery: (() -> ContactQuery)!
    var contactQueryOperator: ContactQueryOperator!
    
    var header: Header!
    var carousel: SelectedContactCarousel!
    var contactListScene: ChikaContactList.Scene!
    
    var data: Data!
    
    public override func loadView() {
        super.loadView()
        
        guard contactListScene != nil, header != nil else {
            return
        }
        
        containerView.addSubview(contactListScene.view)
        addChildViewController(contactListScene)
        contactListScene.didMove(toParentViewController: self)
        
        header.containerView.addSubview(carousel.view)
        addChildViewController(carousel)
        carousel.didMove(toParentViewController: self)
        
        contactListScene.setHeaderView(header)
    }
    
    public override func viewDidLayoutSubviews() {
        guard contactListScene != nil, header != nil else {
            return
        }
        
        var rect = CGRect.zero
        
        rect = containerView.bounds
        contactListScene.view.frame = rect
    }

    @discardableResult
    public func create() -> Result<OK> {
        guard chatCreator != nil, chatCreatorOperator != nil else {
            return .err(Error("there is no service to create a chat"))
        }
        
        guard let title = header?.titleInput.text, !title.isEmpty else {
            return .err(Error("title is empty"))
        }
        
        guard let ids = data?.participantIDs, !ids.isEmpty else {
            return .err(Error("there are no participants"))
        }
        
        let isOK = chatCreatorOperator.withTitle(title).withParticipantIDs(ids).withCompletion(completion).createChat(using: chatCreator())
        
        return (isOK ? .ok(OK("creating your new chat")) : .err(Error("can not create chat")))
    }
    
    func completion(_ result: Result<Chat>) {
        onChatCreated?(result)
    }
    
}

extension Scene: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
