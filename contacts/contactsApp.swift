//
//  contactsApp.swift
//  contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import SwiftUI

@main
struct contactsApp: App {
    @ObservedObject private var model = Model(provider: PhoneConnectivityProvider())

    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environmentObject(model)
        }
    }
}
