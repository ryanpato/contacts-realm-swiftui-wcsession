//
//  ViewModel.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/07.
//

import RealmSwift
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var model: Model?
    
    func setModel(model: Model) {
        self.model = model
    }
    
    // Add a new Contact to the database
    func addContact(name: String) {
        let id = UUID().uuidString

        // Update realm
        let realm = try! Realm()
        try! realm.write {
            let object = Contact()
            object.id = id
            object.name = name
            realm.add(object)
            
            // Notify watch/companion app
            let message = ["type": "add", "name": name, "id": id]
            model?.provider.send(message: message)
        }
    }

    // Remove a contact from the database
    func deleteContact(_ contact: Contact) {
        let realm = try! Realm()
    
        // Check there's an entry
        guard let contact = realm.objects(Contact.self).first(where: { $0.id == contact.id }) else { return }
    
        try! realm.write {
            // Notify watch/companion app
            let message = ["type": "remove", "id": contact.id]
            model?.provider.send(message: message)
            
            // Delete from realm
            realm.delete(contact)
        }
    }
}
