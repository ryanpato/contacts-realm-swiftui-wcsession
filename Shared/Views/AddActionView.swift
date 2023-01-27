//
//  AddActionView.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import SwiftUI

struct AddActionView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Add", systemImage: "person.crop.circle.fill.badge.plus")
        }
        .tint(.blue)
        .padding(.bottom)
    }
}
