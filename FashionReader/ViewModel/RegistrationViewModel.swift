//
//  RegistrationViewModel.swift
//  FRSample
//
//  Created by cmStudent on 2023/02/03.
//

import Foundation
import Combine
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
    }
    @Published var image: UIImage?
    //@Published var filterdImage: UIImage?
    @Published var filterdImage: UIImage? = UIImage(named: "marumattarou")
    
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    
    var imageName: String?
    var imagePath: URL?
    
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    // フィルターバナー表示用フラグ
    @Published var isShowBanner = false
    
    //Registration
    let fileManager = File.shared
    
    // ファイルから読み込んだあと、表示するために使う。書き込みの際は使わない
    //@Published var image: UIImage?
    
    /**
     imageを保存する
     @Param image 保存したい画像
     @Param fileName このファイル名で保存する
     @return
     */
    func save(image: UIImage, fileName: String) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            // TODO: jpegに変換できなかった時の処理
            return
        }
        
        guard let path = fileManager.getLibraryFileURL(fileName: fileName) else {
            // TODO: URLがない時の処理
            return
        }
        
        if fileManager.save(file: imageData, path: path) {
            // 保存先フルパス
            imagePath = path
            imageName = fileName
            print(path.absoluteString)
            print("Preservation Success!")
            UserDefaults.standard.set(path.absoluteString, forKey: "\(fileName)")
            
        } else {
            print("Failure to save.")
        }
            
    }
    
    /**
     指定された名前のファイルを呼び出す
     @Param fileName 呼び出したいファイル名
     @return
     */
    func load(fileName: String) {
        if let path = fileManager.getLibraryFileURL(fileName: fileName) {
            print(path)
            self.image = fileManager.load(path: path)
            
        }
    }
    // Combineを実行するためのCancellable
    var cancellables: [Cancellable] = []
    
    init() {
        // $を付けている（状態変数として使う→今回はPublished→Publisher)
        let imageCancellable = $image.sink { [weak self] uiimage in
            guard let self = self, let uiimage = uiimage else { return }
            
            self.filterdImage = uiimage
        }
        
        cancellables.append(imageCancellable)
    }
    
    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                
            }
        case .tappedActionSheet(let sourceType):
            // フォトライブラリーを起動する（あるいはカメラを起動する？）
            selectedSourceType = sourceType
            isShowImagePickerView = true
        }
    }
}

