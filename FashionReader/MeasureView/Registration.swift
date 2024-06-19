//
//  Registration.swift
//  FRSample
//
//  Created by cmStudent on 2023/02/13.
//

import SwiftUI
import RealmSwift

enum AlertType {
    case alert1
    case alert2
}

struct Registration: View {
    @Environment(\.presentationMode) var presentation
    @State var sizeCount = 5
    @State var isAlert = false
    @EnvironmentObject var store: Clothe
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var cameraViewModel = RegistrationViewModel()
    @State var alertType: AlertType = .alert1
    @State var isShowView = 0
    @State var isRegistration = 0
    @State var select = "トップス"
    @State var itemBrand = ""
    @State var itemName = ""
    @State var arrayResult: [Double] = [0.0]
    @State var isButton = true
    @State var imagePath = ""
    var body: some View {
        NavigationView  {
            if isShowView == 0 {
                InputView(sizeCount: $sizeCount, isShowView: $isShowView, isRegistration: $isRegistration, itemName: $itemName, select: $select, itemBrand: $itemBrand, imagePath: $imagePath, arrayResult: $arrayResult)
                    .environmentObject(store)
            } else {
                MeasureView(arrayResult: $arrayResult, sizeCount: $sizeCount, isButton: $isButton, sizeCat: category(a: sizeCount))
            }
        }
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if isShowView == 0 {
                        self.presentation.wrappedValue.dismiss()
                    } else {
                        isShowView = 0
                    }
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("MainColor"))
                        Text("戻る")
                            .foregroundColor(Color("MainColor"))
                    }
                }
            }
            
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if (itemName.isEmpty || itemName.count <= 0 || itemBrand.isEmpty || itemBrand.count <= 0) {
                        alertType = .alert1
                    } else {
                        alertType = .alert2
                    }
                    isAlert = true
                }) {
                    HStack{
                        Text("登録")
                            .foregroundColor(isButton ? Color.gray : Color("MainColor"))
                        Image(systemName: "checkmark")
                            .foregroundColor(isButton ? Color.gray : Color("MainColor"))
                    }
                }.disabled(isButton)
            }
        }
        .alert(isPresented: $isAlert) {
            switch alertType {
            case .alert1:
                return Alert(title: Text("未入力の欄があります"),
                             message: Text("アイテム名とブランド名を入力してください"),
                             dismissButton: .default(Text("了解")))  // ボタンの変更
            case .alert2:
                return Alert(title: Text("確認"),
                             message: Text("登録してよろしいですか？"),
                             primaryButton: .cancel(Text("キャンセル")),      // 左ボタンの設定
                             secondaryButton: .default(Text("OK"),
                                                       action: {
                    if arrayResult.count <= 3 {
                        arrayResult.append(0.0)
                        arrayResult.append(0.0)
                        arrayResult.append(0.0)
                        arrayResult.append(0.0)
                    }
                    store.create(brandName: itemBrand, itemName: itemName, categoryName: select, itemToggle: false, sizeA: arrayResult[0], sizeB: arrayResult[1], sizeC: arrayResult[2], sizeD: arrayResult[3], imagePath: imagePath)
                    self.presentation.wrappedValue.dismiss()
                }))    // 右ボタンの設定
            }
        }
    }
    func category(a: Int) -> [String]{
        var sizeCategory: [String]
        if a == 5 {
            sizeCategory = ["肩幅", "袖丈", "着丈", "身幅"]
        } else if a == 4 {
            sizeCategory = ["股上", "股下", "パンツ丈"]
        } else {
            sizeCategory = ["縦", "横"]
        }
        return sizeCategory
    }
}

