//
//  Data.swift
//  ChikaChatCreator
//
//  Created by Mounir Ybanez on 2/17/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import ChikaCore

protocol Data {

    var participantIDs: [ID] { get }
    var participantCount: Int { get }
    
    func participantAt(_ index: Int) -> Contact?
    
    @discardableResult
    func insertParticipantAtFirst(_ contact: Contact) -> Bool
    
    @discardableResult
    func removeParticipant(_ contact: Contact) -> Int?
    
    @discardableResult
    func removeParticipantAt(_ index: Int) -> Contact?
}

class DataProvider: Data {
    
    var participants: [Contact]
    
    var participantIDs: [ID] {
        return participants.map({ $0.person.id })
    }
    
    var participantCount: Int {
        return participants.count
    }
    
    init() {
        self.participants = []
    }
    
    func participantAt(_ index: Int) -> Contact? {
        guard index >= 0, index < participantCount else {
            return nil
        }
        
        return participants[index]
    }
    
    @discardableResult
    func insertParticipantAtFirst(_ contact: Contact) -> Bool {
        guard participants.index(of: contact) == nil else {
            return false
        }
        
        participants.insert(contact, at: 0)
        return true
    }
    
    @discardableResult
    func removeParticipant(_ contact: Contact) -> Int? {
        guard let index = participants.index(of: contact) else {
            return nil
        }
        
        participants.remove(at: index)
        return index
    }
    
    @discardableResult
    func removeParticipantAt(_ index: Int) -> Contact? {
        guard index >= 0, index < participantCount else {
            return nil
        }
        
        return participants.remove(at: index)
    }
    
}
