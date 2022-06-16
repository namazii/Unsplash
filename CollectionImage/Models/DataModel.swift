//
//  DataModel.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 10.05.2022.
//

import RealmSwift

class DataElement: Object {
    @Persisted var photo = Data()
    @Persisted var name = ""
    @Persisted var data = ""
    @Persisted var location = ""
    @Persisted var downloads = 0
    @Persisted var id = ""
}
