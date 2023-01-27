//
//  WatchConnectivityProvider.swift
//  contacts Watch App
//
//  Created by Ryan Paterson on 2023/01/27.
//

import RealmSwift
import WatchConnectivity

final class WatchConnectivityProvider: NSObject, ConnectivityProvider {
    @ObservedResults(Contact.self) private var contacts

    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        
        session.delegate = self
        session.activate()
    }
}

// Request Items
extension WatchConnectivityProvider {
    
    // While the Watch has its own Realm for offline use, they need to sync.
    // The phone is the source of truth I suppose so the watch can request?
    func requestContacts() {
        let message = ["type": "contact-request"]
        self.send(message: message)
    }

    func handleContactFetchResponse(with context: [String: Any]) {
        // Verify request payload
        guard
            context["type"] as? String == "contact-response",
            let data = context["contacts"] as? Data
        else { return }
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode([Contact].self, from: data)
        
        // Get all contacts in a transferable dictionary
        decoded.forEach { data in
            let id = data.id
            let name = data.name
            
            // Already exists in the database
            if contacts.where({ $0.id == id }).first != nil {
                // Check if anything has changed but the app doesn't allow edits
            }
            // Doesn't exist in the database
            else {
                // Add to the database
                handleAddContact(with: ["type": "add", "name": name, "id": id])
            }
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityProvider: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error { print(error) }
        
        // On activation request the contacts from the
        requestContacts()
    }

    // If the device wasn't awake when it received a message.
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleAddContact(with: applicationContext)
        handleRemoveContact(with: applicationContext)
        handleContactFetchResponse(with: applicationContext)
    }

    // If the device receives a message while awake.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleAddContact(with: message)
        handleRemoveContact(with: message)
        handleContactFetchResponse(with: message)
    }
}
