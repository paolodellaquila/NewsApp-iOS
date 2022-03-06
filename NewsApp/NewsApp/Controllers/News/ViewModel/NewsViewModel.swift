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
    @Published var news: [Article] = []
    var cancellable: AnyCancellable?

    //MARK: - Providers
    private let newsProvider: NewsProvider
    
    //MARK: - Observables
    var errorState = PassthroughSubject<HandledError, Never>()
    var loadingState = PassthroughSubject<Bool, Never>()
    
    init(newsProvider: NewsProvider = NewsProvider()){
        self.newsProvider = newsProvider
    }
    
}

//MARK: Networking Tasks
extension NewsViewModel{
    
    func loadNews(_ country: String = "it", _ category: String = "business") {
        
        loadingState.send(true)
        
        self.cancellable = newsProvider.fetchNewsByNationAndCategory(country: country, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                
                guard case let .failure(error) = completion else { return }
                
                self?.errorState.send(HandledError(statusCode: 500, description: error.localizedDescription))
                self?.loadingState.send(false)
            
            }, receiveValue: { [weak self] results in
                
                self?.loadingState.send(false)
                
                do {
                    self?.news = try JSONDecoder().decode([Article].self, from: results.data)
                } catch {
                    self?.errorState.send(HandledError(statusCode: results.statusCode, description: error.localizedDescription))
                }
                
            })
    }
    
}
