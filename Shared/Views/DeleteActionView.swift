//
//  DeleteActionView.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import SwiftUI

struct DeleteActionView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red)
    }
}
