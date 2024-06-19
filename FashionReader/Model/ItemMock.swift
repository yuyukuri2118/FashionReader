//
//  ItemMock.swift
//  FRSample
//
//  Created by cmStudent on 2023/01/20.
//

import Foundation
import UIKit

enum ItemMock {
  static let itemMock = [
    clothesData(id: 1, brandName: "BEAMS", itemName: "デニムパンツ", categoryName: "パンツ", isOnMain: false, sizeA: 1.1, sizeB: 1.9, sizeC: 1.1, sizeD: 1.1, imagePath: "", nowState: 0),
    clothesData(id: 2, brandName: "HUF", itemName: "フリース", categoryName: "トップス", isOnMain: false, sizeA: 1.1, sizeB: 1.9, sizeC: 1.1, sizeD: 1.1, imagePath: "", nowState: 1),
    clothesData(id: 3, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false, sizeA: 1.1, sizeB: 1.9, sizeC: 1.1, sizeD: 1.1, imagePath: "", nowState: 2)
  ]
}
