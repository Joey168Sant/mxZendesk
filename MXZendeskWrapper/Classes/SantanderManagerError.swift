//
//  SantanderManagerError.swift
//  MXZendeskWrapper
//
//  Created by MacPro on 02/03/22.
//

import Foundation
struct SantanderManagerError: LocalizedError {
    private let description: String
    var errorDescription: String? { return description }
    
    init(description: String) {
        self.description = description
    }
}

