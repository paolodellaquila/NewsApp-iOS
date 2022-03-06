//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import Foundation
import Combine


class NewsViewModel {
    
    //MARK: Observables properties
    var news: [Article] = []

    //MARK: - Providers
    private let newsProvider: NewsProvider
    
    //MARK: - Observables
    var errorState = PassthroughSubject<String, Never>()
    
    init(newsProvider: NewsProvider = NewsProvider()){
        self.newsProvider = newsProvider
    }
    
}

//MARK: Networking Tasks
extension NewsViewModel{
    
    func loadNews(_ country: String = "it", _ category: String = "business") {
        
        let cancellable = newsProvider.fetchNewsByNationAndCategory(country: country, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                
                guard case let .failure(error) = completion else { return }
                
                self?.errorState.send(error.localizedDescription)
            
            }, receiveValue: { [weak self] results in
                
                do {
                    self?.news = try JSONDecoder().decode([Article].self, from: results.data)
                } catch {
                    self?.errorState.send(error.localizedDescription)
                }
                
            })
    }
    
}
