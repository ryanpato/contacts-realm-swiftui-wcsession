//
//  contactsApp.swift
//  contacts Watch App
//
//  Created by Ryan Paterson on 2023/01/08.
//

import SwiftUI

@main
struct contacts_Watch_AppApp: App {
    @ObservedObject private var model = Model(provider: WatchConnectivityProvider())

    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environmentObject(model)
        }
    }
}
