//
//  ConnectivityManager.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import RealmSwift
import WatchConnectivity

protocol ConnectivityProvider: NSObject, ObservableObject {
    var session: WCSession { get }
    func handleAddContact(with context: [String: Any])
    func handleRemoveContact(with context: [String: Any])
    func send(message: [String: Any]) -> Void
}

extension ConnectivityProvider {
    func send(message: [String: Any]) -> Void {
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { error in
                print(error.localizedDescription)
            }
        } else {
            do {
                try session.updateApplicationContext(message)
            } catch {
                print(error)
            }
        }
    }
}

extension ConnectivityProvider {
    func handleAddContact(with context: [String: Any]) {
        guard
            let type = context["type"] as? String,
            let id = context["id"] as? String,
            let name = context["name"] as? String
        else { return }

        if type == "add" {
            let realm = try! Realm()
            
            // Return if it already exists
            if realm.objects(Contact.self).first(where: { $0.id == id }) != nil { return }
            
            // Otherwise, add a copy to the current devices Realm
            try! realm.write {
                let contact = Contact()
                contact.id = id
                contact.name = name
                realm.add(contact)
            }
        }
    }
 
    func handleRemoveContact(with context: [String: Any]) {
        guard
            let type = context["type"] as? String,
            let id = context["id"] as? String else
        { return }

        if type == "remove" {
            let realm = try! Realm()
            
            // Check if the item exists on this devices realm
            if let match = realm.objects(Contact.self).first(where: { $0.id == id }) {
                
                // Remove
                try! realm.write {
                    realm.delete(match)
                }
            }
        }
    }
}
