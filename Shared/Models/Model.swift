//
//  Model.swift
//  contacts Watch App
//
//  Created by Ryan Paterson on 2023/01/27.
//

import SwiftUI

// App model
final class Model: ObservableObject {
    @Published var provider: any ConnectivityProvider
    
    init(provider: any ConnectivityProvider) {
        self.provider = provider
    }
}
