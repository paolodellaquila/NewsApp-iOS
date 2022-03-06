//
//  NetworkError.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 06/03/22.
//

import Foundation


struct HandledError{
    
    var statusCode: Int
    var description: String
    
    public func readableMessage() -> String {
        return "Status code: \(statusCode) \n \(description)"
    }
    
}
