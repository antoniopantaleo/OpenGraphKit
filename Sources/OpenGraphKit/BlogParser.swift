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
    
    private static func extract(regex: Regex<(Substring, Substring)>, from content: String) throws -> String {
        guard let match = content.firstMatch(of: regex) else { throw Error.quoteNotFound }
        let result = String(match.output.1)
        guard !result.isEmpty else { throw Error.quoteNotFound }
        return result
    }
    
    
    public static func parseBlogData(_ content: String) async throws -> (title: String, quote: String) {
        let titleRegex = /(?:title:\s+)(.+)/
        let quoteRegex = /---\n*(.+)\n*(?=<!--more-->)/
        
        async let title = extract(regex: titleRegex, from: content)
        async let quote = extract(regex: quoteRegex, from: content)
        
        return try await (title, quote)
    }
    
}
