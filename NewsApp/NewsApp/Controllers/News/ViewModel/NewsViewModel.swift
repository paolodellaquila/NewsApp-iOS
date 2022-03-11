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
    @Published var filteredNews: [Article] = []
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
                
                self?.errorState.send(HandledError(status: "Error", code: String(error.errorCode), message: error.errorDescription ?? ""))
                self?.loadingState.send(false)
            
            }, receiveValue: { [weak self] results in
            
                self?.loadingState.send(false)
                
                if(results.statusCode == 200){
                    
                    if let newsResponse = try? JSONDecoder().decode(ArticleResponse.self, from: results.data){
                        self?.news = newsResponse.articles
                        
                    }else{
                        self?.errorState.send(HandledError(status: "Error", code: "", message: "Unable to parse News Json"))
                    }
                    
                }else{
                    
                    if let handledError = try? JSONDecoder().decode(HandledError.self, from: results.data) {
                        self?.errorState.send(handledError)
                        
                    }else{
                        self?.errorState.send(HandledError(status: "Error", code: String(results.statusCode), message: "Network Error"))
                    }
                    
                }
                
            })
    }
    
}
