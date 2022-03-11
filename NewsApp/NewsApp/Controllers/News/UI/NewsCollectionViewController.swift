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
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
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
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &subscriptions)
        
    }

    
    private func setupUI(){
        
        setupNavigationBar()
        
        setupCollectionView()
        
        setupActivityIndicator()
        
        setupSearchbar()

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
 
//MARK: Manage Ui
extension NewsCollectionViewController{
    
    private func setupNavigationBar() {

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        barAppearance.largeTitleTextAttributes = [.foregroundColor : UIColor.secondaryLabel]
        barAppearance.titleTextAttributes = [.foregroundColor : UIColor.secondaryLabel]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    
    private func setupCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        let mosaicLayout = TRMosaicLayout()
        collectionView.setCollectionViewLayout(mosaicLayout, animated: true)
        mosaicLayout.delegate = self
        
        collectionView.register(UINib(nibName: CollectionUtility.cellUIName, bundle: nil), forCellWithReuseIdentifier: CollectionUtility.reuseID)
        
    }
    
    private func setupActivityIndicator() {

        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupSearchbar(){
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.becomeFirstResponder()

        searchController.searchBar.placeholder = "Search News"

        navigationItem.searchController = searchController

        definesPresentationContext = true
    }
    
}

//MARK: Manage collection view
extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout{

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? newsViewModel.filteredNews.count : newsViewModel.news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionUtility.reuseID, for: indexPath) as! NewsCollectionViewCell
        
        let article = isFiltering ? newsViewModel.filteredNews[indexPath.row] : newsViewModel.news[indexPath.row]
        cell.setupCell(article.title, article.urlToImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 150)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article = isFiltering ? newsViewModel.filteredNews[indexPath.row] : newsViewModel.news[indexPath.row]
        if let url = URL(string: article.url) {
            UIApplication.shared.open(url)
        }
    }
    
}

//MARK: Manage searchbar
extension NewsCollectionViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        newsViewModel.filteredNews.removeAll(keepingCapacity: false)
        
        guard let searchText = searchController.searchBar.text else {
            return
        }

        newsViewModel.filteredNews = newsViewModel.news.filter {
            return $0.title .range(of: searchText) != nil
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
}

//MARK: Manage TRM Flow Layout
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
    static let cellUIName = "NewsCollectionViewCell"
    static let reuseID = "newsCell"
    static let headerID = "searchCollectionHeader"
}
