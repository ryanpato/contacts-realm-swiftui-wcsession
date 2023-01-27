//
//  ContactListView.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/08.
//

import RealmSwift
import SwiftUI

struct ContactListView: View {
    @EnvironmentObject private var model: Model
    @ObservedResults(Contact.self) private var results
    @State private var shouldShowModal = false
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(results) { result in
                        Text(result.name)
                            .swipeActions {
                                DeleteActionView {
                                    viewModel.deleteContact(result)
                                }
                            }
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                AddActionView {
                    shouldShowModal = true
                }
            }
            .sheet(isPresented: $shouldShowModal) {
                ContactAddView(viewModel: viewModel)
            }
            .onAppear(){
                // ViewModel に EnvironmentObject を設定
                viewModel.setModel(model: model)
            }
        }
    }
}
