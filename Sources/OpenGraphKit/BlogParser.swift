//
//  BlogParser.swift
//
//
//  Created by Antonio on 27/08/24.
//

import Foundation

public enum BlogParser {
    
    enum Error: Swift.Error {
        case titleNotFound
        case quoteNotFound
    }
    
    public static func parseBlogData(_ content: String) async throws -> (title: String, quote: String) {
        let titleRegex = /(?:title:\s+)(?<title>.+)/
        let quoteRegex = /---\n*(?<quote>.+)\n*(?=<!--more-->)/
        
        async let titleMatch = content.firstMatch(of: titleRegex)
        async let quoteMatch = content.firstMatch(of: quoteRegex)
    
        guard let titleMatch = await titleMatch, let title = Optional(String(titleMatch.output.title)), !title.isEmpty else { throw Error.titleNotFound }
        guard let quoteMatch = await quoteMatch, let quote = Optional(String(quoteMatch.output.quote)), !quote.isEmpty else { throw Error.quoteNotFound }
        
        return (title, quote)
    }
    
}
