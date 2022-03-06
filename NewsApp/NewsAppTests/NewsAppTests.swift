//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {
    
    func check_if_newsapi_token_is_set(){
        
        let checkContains = Constants.API.apiKey.contains("*")
        
        XCTAssertFalse(checkContains)
    }
    
    func check_if_baseUrl_is_set(){
        
        let checkEmpty = Constants.API.baseUrl.isEmpty
        
        XCTAssertFalse(checkEmpty)
    }

}
