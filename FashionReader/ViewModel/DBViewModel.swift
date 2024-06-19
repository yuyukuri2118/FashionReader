//
//  ViewModelDB.swift
//  FRSample
//
//  Created by cmStudent on 2023/01/20.
//

import RealmSwift
import SwiftUI

final class Clothe: ObservableObject {
    @AppStorage("a") var nowState = 0

    private var clotheResults: Results<ClothesDB> = {
        guard let realm = try? Realm() else {
            fatalError("Failed to create Realm instance")
        }
        return realm.objects(ClothesDB.self)
    }()
    
    var items: [clothesData] {
        clotheResults.map(clothesData.init)
    }
    
    private func handleRealmError(_ error: Error) {
        print(error.localizedDescription)
    }
}

extension Clothe {
    // データを追加
    func create(brandName: String, itemName: String, categoryName: String, itemToggle: Bool, sizeA: Double, sizeB: Double, sizeC: Double, sizeD: Double, imagePath: String) {
        objectWillChange.send()
        do {
            let realm = try Realm()
            let clothesDB = ClothesDB()
            clothesDB.id = UUID().hashValue
            clothesDB.brandName = brandName
            clothesDB.itemName = itemName
            clothesDB.categoryName = categoryName
            clothesDB.isOnMain = itemToggle
            clothesDB.sizeA = sizeA
            clothesDB.sizeB = sizeB
            clothesDB.sizeC = sizeC
            clothesDB.sizeD = sizeD
            clothesDB.imagePath = imagePath
            clothesDB.nowState = nowState
                
            try realm.write {
                realm.add(clothesDB)
                nowState += 1
            }
            
        } catch let error {
            handleRealmError(error)
        }
    }
    
    func image() {
        
    }
    
    func findById(itemName: Int) -> Results<ClothesDB> {
        let realm = try! Realm()
        let clothes = realm.objects(ClothesDB.self).filter("id == %@", itemName)
        return clothes
    }
    func getSortedClothes(word: String, sort: String ,categoryName: String) -> Results<ClothesDB> {
        var a = false
        var sortName = ""
        var category = ""
        let realm = try! Realm()
        var clothes = realm.objects(ClothesDB.self)
        if sort == "古い順" {
            a = true
            sortName = "nowState"
        } else if sort == "五十音順" {
            sortName = "itemName"
            a = true
        } else {
            sortName = "nowState"
        }
        
        if categoryName == "全て" {
            if (word == "" || word == " ") {
                clothes = realm.objects(ClothesDB.self).sorted(byKeyPath: "\(sortName)", ascending: a)
            } else {
                clothes = realm.objects(ClothesDB.self).filter("brandName CONTAINS[c] %@ OR itemName CONTAINS[c] %@", word, word).sorted(byKeyPath: "\(sortName)", ascending: a)
            }
        } else {
            if (word == "" || word == " ") {
                clothes = realm.objects(ClothesDB.self).filter("categoryName == %@", categoryName).sorted(byKeyPath: "\(sortName)", ascending: a)
            } else {
                clothes = realm.objects(ClothesDB.self).filter("(brandName CONTAINS[c] %@ OR itemName CONTAINS[c] %@) AND categoryName == %@", word, word, categoryName).sorted(byKeyPath: "\(sortName)", ascending: a)
            }
        }
                    
        
        //let clothes = realm.objects(ClothesDB.self).sorted(byKeyPath: "\(sortName)", ascending: a)
        return clothes
    }
    
    // データを更新
    func update(itemID: Int, brandName: String, itemName: String, categoryName: String, itemToggle: Bool) {
        objectWillChange.send()
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(ClothesDB.self,
                             value: ["id": itemID,
                                     "brandName": brandName,
                                     "itemName": itemName,
                                     "categoryName": categoryName,
                                     "isOnMain": itemToggle
                                    ],
                             update: .modified)
            }
        } catch let error {
            handleRealmError(error)
        }
    }
    
    // データを削除
    func delete(itemID: Int) {
        objectWillChange.send()
        guard let clothesDB = clotheResults.first(where: { $0.id == itemID})
        else {
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(clothesDB)
            }
        } catch let error {
            handleRealmError(error)
            print(error.localizedDescription)
        }
    }
    
    // データを全削除
    func deleteAll() {
        objectWillChange.send()
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
