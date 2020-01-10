//
//  Note.swift
//  Notes
//
//  Created by Devin Ghumman on 1/10/20.
//  Copyright © 2020 Devin Ghumman. All rights reserved.
//

import Foundation

class Note: Codable {
    var bodyText: String
    
    init(bodyText: String) {
        self.bodyText = bodyText
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        rhs.bodyText == lhs.bodyText
    }
}
