//
//  NewsApi.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import Foundation
import Moya

enum NewsApi {
    case recentNews(country: String, category: String)
}

extension NewsApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.baseUrl) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .recentNews:
            return "top-headlines"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .recentNews(let country, let category):
            
            //check token
            if(Constants.API.apiKey.isEmpty){
                //insert news api token into Constant file
                fatalError()
            }
            
            return .requestParameters(parameters: ["country" : country, "category" : category, "apiKey": Constants.API.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
