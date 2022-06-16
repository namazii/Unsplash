//
//  ViewController.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 08.05.2022.
//

import UIKit

class ImageViewController: UIViewController {

    var buttonColor = false
    var dataElement: DataElement? {
        didSet{
            Task {
                do {
                  try await getData(with: dataElement)
                    likeButtonOutlet.isHidden = true
                } catch {
                    print(error)
                }
            }
        }
    }
    var dataImage: Data?
    var imageElement: ImageElement? {
        didSet{
            getImage(with: imageElement)
        }
    }
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        likeButtonOutlet.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        checkImage(with: imageElement)
    }
    
    @IBAction func InfoButton(_ sender: UIBarButtonItem) {
        if imageElement != nil {
            showAlert(data: imageElement)
        } else {
            showAlert(data: dataElement)
        }
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        saveImage(imageElement: imageElement, data: dataImage)
        if buttonColor {
            sender.imageView?.tintColor = UIColor.systemBlue
        } else {
            sender.imageView?.tintColor = UIColor.red
        }
    }
    
//MARK: Data
    
    private func getData(with dataElement: DataElement?) async throws {
        guard let dataElement = dataElement else { return }
        guard let image = UIImage(data: dataElement.photo) else { return }
        imageView.image = image
    }
    
    private func getImage(with imageElement: ImageElement?) {
        guard let imageElement = imageElement else { return }
        guard let url = URL(string: imageElement.urls.regular) else { return }
        Task {
            do {
                let data = try await NetworkManager.shared.fetchImage(from: url)
                dataImage = data
                guard let image = UIImage(data: data) else { return }
                imageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    private func checkImage(with: ImageElement?) {
        guard let imageElement = imageElement else { return }
        let data = DataElement()
        data.id = imageElement.id
        buttonColor = StorageManager.shared.checkData(data)
        if buttonColor {
            likeButtonOutlet.imageView?.tintColor = UIColor.systemBlue
        } else {
            likeButtonOutlet.imageView?.tintColor = UIColor.red
        }
    }
    private func saveImage(imageElement: ImageElement?, data: Data?) {
        guard let imageElement = imageElement else { return }
        guard let data = data else { return }
        
        let collection = DataElement()
        collection.photo = data
        collection.name = imageElement.user.name
        collection.data = imageElement.createdAt
        collection.location = imageElement.location.name ?? "no location"
        collection.downloads = imageElement.downloads
        collection.id = imageElement.id
        buttonColor = StorageManager.shared.save(collection)
        
    }
}
extension ImageViewController {
    private func showAlert(data: ImageElement?) {
        let loc = data?.location.name ?? ""
        let alert = UIAlertController(
            title: "Information",
            message: """
            Downloads: \(data?.downloads ?? 0)
            Date: \(data?.createdAt ?? "")
            Location: \(loc)
            Name: \(data?.user.name ?? "")
            """,
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Close", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    private func showAlert(data: DataElement?) {
        let alert = UIAlertController(
            title: "Information",
            message: """
            Downloads: \(data?.downloads ?? 0)
            Date: \(data?.data ?? "")
            Location: \(data?.location ?? "")
            Name: \(data?.name ?? "")
            """,
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Close", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func getDate(_ string: String) -> Date? {
        let isoDate = string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let date = dateFormatter.date(from: isoDate)
        return date
  }
}

