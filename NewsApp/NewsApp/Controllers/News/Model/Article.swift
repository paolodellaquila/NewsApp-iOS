//
//  Article.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
