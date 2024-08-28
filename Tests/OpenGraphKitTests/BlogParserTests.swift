//
//  BlogParserTests.swift
//  
//
//  Created by Antonio on 27/08/24.
//

import XCTest
import OpenGraphKit

final class BlogParserTests: XCTestCase {
    
    func test() async throws {
        let content = """
        ---
        author: Antonio Pantaleo
        title: Decorator Pattern, a personal favorite
        date: 2024-08-21T12:20:05+02:00
        draft: false
        ---

        Adding features without touching existing code; is it even possible?

        <!--more-->

        At first glance, it might seem impractical, if not impossible. Yet, with the right design pattern, this becomes not only feasible but elegantly simple. Today, we’ll explore the `Decorator Pattern`, a structural Design Pattern that allows us to *add functionality to a class without altering its code*.

        ## A Real-World Example
        """
        let result = try await BlogParser.parseBlogData(content)
        XCTAssertEqual(result.title, "Decorator Pattern, a personal favorite")
        XCTAssertEqual(result.quote, "Adding features without touching existing code; is it even possible?")
    }
    
}
