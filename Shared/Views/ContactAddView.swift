//
//  ContactAddView.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import SwiftUI

struct ContactAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Form {
            TextField("Name", text: $name)

            Button("Submit") {
                viewModel.addContact(name: name)
                dismiss.callAsFunction()
            }
        }
    }
}
