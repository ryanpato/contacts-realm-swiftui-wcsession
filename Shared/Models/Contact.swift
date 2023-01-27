//
//  Model.swift
//  Contacts
//
//  Created by Ryan Paterson on 2023/01/07.
//

import Foundation
import RealmSwift

class Contact: Object, Identifiable, Codable {
    @Persisted(indexed: true) var id: String = ""
    @Persisted(indexed: true) var name: String = ""
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
    }
}
