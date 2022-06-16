//
//  ImageTableViewController.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 05.05.2022.
//

import RealmSwift
import UIKit

class ImageTableViewController: UITableViewController {
    
    var dataCollections: Results<DataElement>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 150
        dataCollections = StorageManager.shared.realm.objects(DataElement.self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataCollections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let dataItem = dataCollections[indexPath.row]
        content.image = UIImage(data: dataItem.photo)
        content.text = dataItem.name
        content.imageProperties.cornerRadius = 30
        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        StorageManager.shared.deleteData(dataCollections[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
        let image = dataCollections[indexPath.row]
        guard let imageVC = segue.destination as? ImageViewController else { return }
        imageVC.dataElement = image
    }

}
