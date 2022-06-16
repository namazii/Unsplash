//
//  ImageCollectionViewController.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 05.05.2022.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {
    
    var collections: ImageResult?
    var imageCollections: [ImageElement] = []
    var links: [String] = []
    var linkSearch = ""
    private var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        getCollection()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageCollections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "collectionCell",
                for: indexPath) as? ImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        let imageLink = links[indexPath.item]
        cell.configure(with: imageLink)
        
        return cell
    }
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    private func getCollection() {
        Task {
            do {
                imageCollections.append(contentsOf: try await NetworkManager.shared.fetchCollection(
                    url: NetworkManager.shared.linkURL
                ))
                links.append(contentsOf: imageCollections.map{$0.urls.regular})
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = imageCollections[indexPath.item]
        performSegue(withIdentifier: "showImage", sender: collection)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let image = imageCollections[indexPath.row]
        guard let imageVC = segue.destination as? ImageViewController else { return }
        imageVC.imageElement = image
        
    }
    
    
}
extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
}
                                            
extension ImageCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
extension ImageCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.linkSearch = NetworkManager.shared.request(searchTerm: searchText)
            print(self.linkSearch)
            Task{
                do {
                    self.collections = try await NetworkManager.shared.fetchResult(url: self.linkSearch)
//                    self.links.append(contentsOf: self.imageCollections.map{$0.urls.regular})
                    self.collectionView.reloadData()
                } catch {
                    print(error)
                }
            }
        })
    }
}
