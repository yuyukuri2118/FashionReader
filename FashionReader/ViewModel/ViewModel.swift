//
//  ViewModel.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/01.
//

import Foundation
import SwiftUI
import RealmSwift
import UserNotifications


class ViewModel: ObservableObject {
    @Published var image = UIImage(named: "dummy")
    @Published var path = ""
    @Published var selectLeft = true
    @Published var selectRight = false
    @Published var isOn = false
    @Published var clothesData: [clothesDatas] = [
        clothesDatas(id: 1, brandName: "BEAMS", itemName: "デニムパンツ", categoryName: "パンツ", isOnMain: false),
        clothesDatas(id: 2, brandName: "HUF", itemName: "フリース", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 3, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 4, brandName: "GU", itemName: "Tシャツ", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 5, brandName: "URBAN RESEARCH", itemName: "ムートンコート", categoryName: "アウター", isOnMain: false),
        clothesDatas(id: 6, brandName: "united tokyo", itemName: "カーゴパンツ", categoryName: "パンツ", isOnMain: false),
        clothesDatas(id: 7, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 8, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 9, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false),
        clothesDatas(id: 10, brandName: "UNIQLO", itemName: "エアリズムT", categoryName: "トップス", isOnMain: false),
    ]
    
    //ClothingDataView
    func changeIsOnMain(a: Int) {
        if clothesData[a - 1].isOnMain { clothesData[a - 1].isOnMain = false }
        else { clothesData[a - 1].isOnMain = true }
    }
    
    
    
    //CompareView
    func toggleSelect(judgeNumber: Int){
        if selectLeft {
            if (judgeNumber != 0) {
                selectLeft = false
                selectRight = true
            }
        } else {
            if (judgeNumber != 1) {
                selectLeft = true
                selectRight = false
            }
        }
    }
    
    func setImage(imagePath: String?) -> UIImage {
        guard let imagePath = imagePath else {
            return UIImage(named: "dummy")! // nil合体演算子を使用して、"dummy"画像がnilでない場合にはそれを、nilであればデフォルトの空のUIImageを返すようにしています。
        }
        guard let savedImagePath = UserDefaults.standard.string(forKey: "\(imagePath)")?.replacingOccurrences(of: "file://", with: "") else {
            return UIImage(named: "dummy")! // ユーザーデフォルトから取得した保存先のパスがnilの場合、デフォルトの画像を返します。
        }
        let savedImageURL = URL(fileURLWithPath: savedImagePath)
        do {
            let savedImageData = try Data(contentsOf: savedImageURL)
            print("\(savedImagePath)")
            return UIImage(data: savedImageData) ?? UIImage(named: "dummy")! // UIImage(data:)がnilを返す場合は、"dummy"画像がnilでない場合にはそれを、nilであればデフォルトの空のUIImageを返すようにしています。
        } catch {
            print("\(savedImagePath)")
            return UIImage(named: "dummy") ?? UIImage() // データの読み込みに失敗した場合、デフォルトの画像を返します。
        }
    }
    
    
    
//        guard let imagePath = imagePath else {
//            return UIImage(named: "dummy")!
//        }
//        let newImagePath = imagePath.replacingOccurrences(of: "Optional(file://", with: "").replacingOccurrences(of: ")", with: "")
//        let imagePathURL = URL(fileURLWithPath: newImagePath)
//        do {
//            let image = try Data(contentsOf: imagePathURL)
//            print("\(newImagePath)")
//            return UIImage(data: image) ?? UIImage(named: "dummy")!
//        } catch {
//            return UIImage(named: "dummy")!
//        }

    //通知
    
    func makeNotification(isOn: Bool){
        //②通知タイミングを指定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 50000, repeats: false)

        //③通知コンテンツの作成
        let content = UNMutableNotificationContent()
        content.title = "Fashion Reader"
        content.body = "サイズで悩んでいませんか？\n今すぐ自分の服と比較してみましょう"
        content.sound = UNNotificationSound.default
        
        //④通知タイミングと通知内容をまとめてリクエストを作成。
        let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
        
        if isOn {
            //⑤④のリクエストの通りに通知を実行させる
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            stopNotification()
        }
    }
    func stopNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification001"])
    }
}

class ResultInt: ObservableObject {
    @Published var result = 0
}
 
