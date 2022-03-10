//
//  NewsCollectionViewController.swift
//  NewsApp
//
//  Created by Francesco Paolo Dellaquila on 04/03/22.
//

import UIKit
import Combine


class NewsCollectionViewController: UICollectionViewController, TRMosaicLayoutDelegate {
    
    
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
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
    }
    
    private func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        
        let mosaicLayout = TRMosaicLayout()
        collectionView.setCollectionViewLayout(mosaicLayout, animated: true)
        mosaicLayout.delegate = self
        
        collectionView.register(UINib(nibName: CollectionUtility.cellUIName, bundle: nil), forCellWithReuseIdentifier: CollectionUtility.reuseID)
        
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
extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout{

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return newsViewModel.news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionUtility.reuseID, for: indexPath) as! NewsCollectionViewCell
        
        let article = newsViewModel.news[indexPath.row]
        cell.setupCell(article.title, article.urlToImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 150)
        
    }
    
}

extension NewsCollectionViewController {
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
}


private enum CollectionUtility {
    static let spacing: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let cellUIName = "NewsCollectionViewCell"
    static let reuseID = "newsCell"
}
