//
//  DBModel.swift
//  FRSample
//
//  Created by cmStudent on 2023/01/18.
//

import RealmSwift

class ClothesDB: Object {
    @objc dynamic var id = 0
    @objc dynamic var brandName = ""
    @objc dynamic var itemName = ""
    @objc dynamic var categoryName = ""
    @objc dynamic var isOnMain = false
    @objc dynamic var sizeA = 0.0
    @objc dynamic var sizeB = 0.0
    @objc dynamic var sizeC = 0.0
    @objc dynamic var sizeD = 0.0
    @objc dynamic var imagePath = ""
    @objc dynamic var nowState = 0
    // 主キーを使うと、データの更新や削除に便利
    override static func primaryKey() -> String? {
        "id"
    }
}
