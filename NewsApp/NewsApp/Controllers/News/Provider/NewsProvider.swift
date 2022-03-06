//
//  NewsProvider.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import Foundation
import Moya
import Combine
import CombineMoya

protocol NewsNetworkAPI {
    
    var provider: MoyaProvider<NewsApi> { get }

    func fetchNewsByNationAndCategory(country: String, category: String) -> AnyPublisher<Response, MoyaError>

}

class NewsProvider: NewsNetworkAPI {

    internal var provider = MoyaProvider<NewsApi>(plugins: [NetworkLoggerPlugin()])
    
    func fetchNewsByNationAndCategory(country: String, category: String) -> AnyPublisher<Response, MoyaError> {
        
        return self.provider.requestPublisher(.recentNews(country: country, category: category))
  
    }
    
}
