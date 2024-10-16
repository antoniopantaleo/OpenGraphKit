//
//  OpenGraphKit+Error.swift
//  OpenGraphKit
//
//  Created by Antonio on 16/10/24.
//

import Foundation

extension OpenGraphKit {
    
    struct Error: Swift.Error, CustomStringConvertible {
        
        private let reason: String
        
        init(reason: String) {
            self.reason = reason
        }
        
        var description: String { reason }
    }
    
}
