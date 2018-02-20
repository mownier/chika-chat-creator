//
//  Factory.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import ChikaUI
import ChikaCore
import ChikaFirebase
import ChikaContactList

public final class Factory {

    var onChatCreated: ((Result<Chat>) -> Void)?
    
    public init() {
    }
    
    public func onChatCreated(_ block: @escaping (Result<Chat>) -> Void) -> Factory {
        onChatCreated = block
        return self
    }
    
    public func build() -> Scene {
        defer {
            onChatCreated = nil
        }
        
        let bundle = Bundle(for: Factory.self)
        let storyboard = UIStoryboard(name: "ChatCreator", bundle: bundle)
        let scene = storyboard.instantiateInitialViewController() as! Scene
        
        scene.header = bundle.loadNibNamed("Header", owner: nil, options: nil)![0] as! Header
        
        scene.data = DataProvider()
        
        scene.onChatCreated = onChatCreated
        
        scene.chatCreator = { ChatCreator() }
        scene.chatCreatorOperator = ChatCreatorOperation()
        
        scene.contactQuery = { ContactQuery() }
        scene.contactQueryOperator = ContactQueryOperation()
        
        let carouselFactory = SelectedContactCarouselFactory()
        
        scene.carousel = carouselFactory.withItemCount({
            scene.data?.participantCount ?? 0
            
        }).withItemSize({
            CGSize(width: 80, height: 128)
            
        }).withItemAt({ index in
            guard let participant = scene.data?.participantAt(index)?.person else {
                return SelectedContactCarouselCellItem()
            }
            
            var item = SelectedContactCarouselCellItem()
            item.avatarURL = participant.avatarURL
            item.displayName = participant.displayName
            return item
            
        }).withPlaceholderCellText({
            "Add People"
            
        }).onRemoveItemAt({ index in
            guard let contactID = scene.data?.removeParticipantAt(index)?.person.id else {
                return false
            }
            
            scene.contactListScene?.deselectContact(withIDs: [contactID])
            return true
            
        }).build()
        
        let contactListFactory = ChikaContactList.Factory()
        
        scene.contactListScene = contactListFactory.isSelectionEnabled({
            true
        
        }).onSelectContact({
            guard let isOK = scene.data?.insertParticipantAtFirst($0), isOK else {
                return
            }
            
            scene.carousel?.insertItemAtFirst()
        
        }).onDeselectContact({
            guard let index = scene.data?.removeParticipant($0) else {
                return
            }
            
            scene.carousel?.removeItem(at: index)
            
        }).build()
        
        return scene
    }
    
}
