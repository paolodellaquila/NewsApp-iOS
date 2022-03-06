//
//  NewsCollectionViewController.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import UIKit
import Combine

private let reuseIdentifier = "Cell"

class NewsCollectionViewController: UICollectionViewController {

    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let newsViewModel = NewsViewModel()
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        newsViewModel.loadNews()
        
        newsViewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                print(items)
            }
            .store(in: &subscriptions)
        
    }
    
    private func setupUI(){
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    private func setupBinding(){
        
        newsViewModel.loadingState
            .sink(receiveValue: { [weak self] state in
                
                if(state){
                    self?.activityIndicator.startAnimating()
                }else{
                    self?.activityIndicator.stopAnimating()
                }
                
                
            }).store(in: &subscriptions)
        
        newsViewModel.errorState
            .sink(receiveValue: { [weak self] error in
                self?.showAlert(title: "Ops an error is occured", message: error.readableMessage())
            }).store(in: &subscriptions)
        
    }
    
}
 

//MARK: Manage collection view
extension NewsCollectionViewController{

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }
    
}