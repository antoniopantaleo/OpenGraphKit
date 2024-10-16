//
//  BlogParserTests.swift
//  
//
//  Created by Antonio on 27/08/24.
//

import XCTest
import OpenGraphKit

final class BlogParserTests: XCTestCase {
    
    func testParser_extractTitleAndQuoteCorrectly() async throws {
        let content = """
        ---
        author: Antonio Pantaleo
        title: Decorator Pattern, a personal favorite
        date: 2024-08-21T12:20:05+02:00
        draft: false
        ---

        This is a quote

        <!--more-->

        At first glance, it might seem impractical, if not impossible. Yet, with the right design pattern, this becomes not only feasible but elegantly simple. Today, we’ll explore the `Decorator Pattern`, a structural Design Pattern that allows us to *add functionality to a class without altering its code*.

        ## A Real-World Example
        """
        let (title, quote) = try await BlogParser.parseBlogData(content)
        XCTAssertEqual(title, "Decorator Pattern, a personal favorite")
        XCTAssertEqual(quote, "This is a quote")
    }
    
    func testParser_throwsErrorWhenNoTitleIsFound() async {
        let content = """
        ---
        author: Antonio Pantaleo
        date: 2024-08-21T12:20:05+02:00
        draft: false
        ---

        This is a quote

        <!--more-->

        At first glance, it might seem impractical, if not impossible. Yet, with the right design pattern, this becomes not only feasible but elegantly simple. Today, we’ll explore the `Decorator Pattern`, a structural Design Pattern that allows us to *add functionality to a class without altering its code*.

        ## A Real-World Example
        """
        do {
            let result = try await BlogParser.parseBlogData(content)
            XCTFail("Expected error to be thrown, got \(result) instead.")
        } catch {}
    }
    
    func testParser_throwsErrorWhenNoQuoteIsFound() async {
        let content = """
        ---
        author: Antonio Pantaleo
        title: Decorator Pattern, a personal favorite
        date: 2024-08-21T12:20:05+02:00
        draft: false
        ---
        
        At first glance, it might seem impractical, if not impossible. Yet, with the right design pattern, this becomes not only feasible but elegantly simple. Today, we’ll explore the `Decorator Pattern`, a structural Design Pattern that allows us to *add functionality to a class without altering its code*.

        ## A Real-World Example
        """
        do {
            let result = try await BlogParser.parseBlogData(content)
            XCTFail("Expected error to be thrown, got \(result) instead.")
        } catch {}
    }
    
    func testParser_throwsErrorWhenNoQuoteAndNoTitleAreFound() async {
        let content = """
        ---
        author: Antonio Pantaleo
        date: 2024-08-21T12:20:05+02:00
        draft: false
        ---
        
        At first glance, it might seem impractical, if not impossible. Yet, with the right design pattern, this becomes not only feasible but elegantly simple. Today, we’ll explore the `Decorator Pattern`, a structural Design Pattern that allows us to *add functionality to a class without altering its code*.

        ## A Real-World Example
        """
        do {
            let result = try await BlogParser.parseBlogData(content)
            XCTFail("Expected error to be thrown, got \(result) instead.")
        } catch {}
    }
    
    func testParser_throwsErrorWithEmptyContent() async {
        let content = ""
        do {
            let result = try await BlogParser.parseBlogData(content)
            XCTFail("Expected error to be thrown, got \(result) instead.")
        } catch {}
    }
    
}
