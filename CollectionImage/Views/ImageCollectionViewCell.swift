//
//  ImageCollectionViewCell.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 06.05.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var imageURL: URL? {
        didSet {
            imageView.image = nil
            updateImage()
        }
    }
    
    func configure(with url: String) {
        imageURL = URL(string: url)
    }
    
    private func updateImage() {
        guard let url = imageURL else { return }
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                if url == self.imageURL {
                    self.imageView.image = image
            }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let cacheImage = ImageCache.shared.object(forKey: url.lastPathComponent as NSString) {
            completion(.success(cacheImage))
        }
        Task {
            do {
                let imageData = try await NetworkManager.shared.fetchImage(from: url)
                guard let image = UIImage(data: imageData) else { return }
                ImageCache.shared.setObject(image, forKey: url.lastPathComponent as NSString)
                completion(.success(image))
            } catch {
                print(error)
            }
        }
    }
}

