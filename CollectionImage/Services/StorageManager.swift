//
//  Datamanager.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 10.05.2022.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func save(_ dataElement: DataElement) -> Bool {
        var check = false

        let predicate = NSPredicate(format: "id == %@", dataElement.id)
        if let delete = realm.objects(DataElement.self).filter(predicate).first {
            write {
                realm.delete(delete)
                check.toggle()
            }
        } else {
            write {
                realm.add(dataElement)
            }
        }
        return check
    }
    func checkData(_ dataElement: DataElement) -> Bool {
        var check = true
        let predicate = NSPredicate(format: "id == %@", dataElement.id)
        if let _ = realm.objects(DataElement.self).filter(predicate).first {
                check.toggle()
        } else {
            
        }
        return check
    }
    func deleteData(_ dataElement: DataElement) {
        write {
            realm.delete(dataElement)
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
