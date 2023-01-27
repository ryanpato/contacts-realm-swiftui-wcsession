//
//  PhoneConnectivityProvider.swift
//  contacts
//
//  Created by Ryan Paterson on 2023/01/27.
//

import RealmSwift
import WatchConnectivity

final class PhoneConnectivityProvider: NSObject, ConnectivityProvider {
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

extension PhoneConnectivityProvider {
    func handleContactFetchRequest(with context: [String: Any]) {
        // Verify request payload
        guard context["type"] as? String == "contact-request" else { return }

        // Get all contacts in a transferable dictionary
        let realm = try! Realm()
        let contacts = Array(realm.objects(Contact.self))
        let encoder = JSONEncoder()
        let data = try! encoder.encode(contacts)

        // Compose message to watch
        let message: [String: Any] = ["type": "contact-response", "contacts": data]
        self.send(message: message)
    }
}

// MARK: - WCSessionDelegate
extension PhoneConnectivityProvider: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error { print(error) }
    }

    // If the device wasn't awake when it received a message.
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleContactFetchRequest(with: applicationContext)
        handleAddContact(with: applicationContext)
        handleRemoveContact(with: applicationContext)
    }

    // If the device receives a message while awake.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleContactFetchRequest(with: message)
        handleAddContact(with: message)
        handleRemoveContact(with: message)
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
}
