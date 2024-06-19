//
//  InputView.swift
//  FRSample
//
//  Created by cmStudent on 2023/02/22.
//

import SwiftUI


struct InputView: View {
    @State var alertType: AlertType = .alert1
    @Binding var itemName: String
    @State var itemCategory = ""
    @Binding var itemBrand: String
    @State var selectRow: [String] = ["トップス","アウター","ボトム","バッグ"]
    @Binding var select: String
    @State private var showingAlert = false
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var cameraViewModel = RegistrationViewModel()
    @EnvironmentObject var store: Clothe
    @Binding var sizeCount: Int
    @Binding var isShowView: Int
    @Binding var isRegistration: Int
    @Binding var imagePath: String
    @Binding var arrayResult: [Double]
    @State var img = UIImage(named: "dummy")
    @Environment(\.presentationMode) var presentation
    init(sizeCount: Binding<Int>, isShowView: Binding<Int>, isRegistration: Binding<Int>, itemName: Binding<String>, select: Binding<String>, itemBrand: Binding<String>, imagePath: Binding<String>, arrayResult: Binding<[Double]>) {
        self._sizeCount = sizeCount
        self._isShowView = isShowView
        self._isRegistration = isRegistration
        self._itemName = itemName
        self._select = select
        self._itemBrand = itemBrand
        self._imagePath = imagePath
        self._arrayResult = arrayResult
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.white], for: .normal
        )
        
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.black], for: .selected
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Button {
                    cameraViewModel.isShowActionSheet = true
                    //                viewModel.addData(iname: itemName, cname: itemCategory, bname: itemBrand)
                } label: {
                    if let image = cameraViewModel.filterdImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("MainColor"), lineWidth: 10)
                            )
                            .onTapGesture {
                                withAnimation {
                                    cameraViewModel.isShowBanner = true
                                }
                            }
                        
                    } else {
                        Rectangle()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("MainColor"), lineWidth: 10)
                            )
                    }
                }
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 7)
                .onAppear{
                    // 画面表示時の処理
                    cameraViewModel.apply(.onAppear)
                }
                .actionSheet(isPresented: $cameraViewModel.isShowActionSheet) {
                    actionSheet
                }
                .sheet(isPresented: $cameraViewModel.isShowImagePickerView) {
                    ImagePicker(isShown: $cameraViewModel.isShowImagePickerView,
                                image: $cameraViewModel.image,
                                sourceType: cameraViewModel.selectedSourceType)
                }
                
                
                ZStack{
                    Picker(selection: $select, label: Text("").foregroundColor(.black)) {
                        ForEach(0..<self.selectRow.count) { id in
                            Text(selectRow[id]).tag(0).tag(self.selectRow[id])
                                .foregroundColor(.white)
                        }
                    }
                    .background(Color("MainColor"))
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: geometry.size.width / 1.2)
                    .cornerRadius(10)
                    .clipped()
                    
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width / 1.2, height: 250)
                            .foregroundColor(.gray.opacity(0.2))
                            .cornerRadius(7)
                        VStack {
                            Text("ブランド名")
                            TextField ("ブランド名", text: $itemBrand, onCommit:{})
                                .frame(width: geometry.size.width / 1.4)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.all)
                            Divider()
                                .frame(width: geometry.size.width / 1.4)
                            
                            Text("アイテム名")
                            TextField ("アイテム名", text: $itemName, onCommit:{})
                                .frame(width: geometry.size.width / 1.4)
                                .font(.callout)
                                .fontWeight(.light)
                                .padding(.all)
                            Divider()
                                .frame(width: geometry.size.width / 1.4)
                        }
                    }.offset(y: 170)
                    ZStack{
                        Button {
                            if (itemName.isEmpty || itemName.count <= 0 || itemBrand.isEmpty || itemBrand.count <= 0) {
                                showingAlert = true
                            } else {
                                if (cameraViewModel.filterdImage != nil) {
                                    let random = Double.random(in: 0..<10.000)
                                    if cameraViewModel.filterdImage == nil {
                                        cameraViewModel.save(image: img!, fileName: "\(random)")
                                    } else {
                                        cameraViewModel.save(image: cameraViewModel.filterdImage!, fileName: "\(random)")
                                    }
                                    imagePath = "\(random)"
                                }
                                if select == "トップス" {
                                    sizeCount = 5
                                } else if select == "アウター" {
                                    sizeCount = 5
                                } else if select == "ボトム" {
                                    sizeCount = 4
                                } else if select == "バッグ" {
                                    sizeCount = 3
                                } else {
                                    sizeCount = 5
                                }
                                arrayResult = Array (repeating: 0.0, count: sizeCount)
                                isShowView = 1
                            }
                            //showingAlert.toggle()
                        } label: {
                            Rectangle()
                                .frame(width: 140, height: 70)
                                .foregroundColor(Color("MainColor"))
                                .cornerRadius(10)
                            
                        }
                        Text("次へ")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                            .font(.title)
                    }
                    .offset(y: geometry.size.height / 2 + 35)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 3)
            }
            .navigationBarBackButtonHidden(true)
        }
        .onChange(of: isRegistration, perform: { num in
            //store.create(brandName: itemBrand, itemName: itemName, categoryName: select, itemToggle: false)
        })
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("未入力の欄があります"),
                  message: Text("アイテム名とブランド名を入力してください"),
                  dismissButton: .default(Text("了解")))  // ボタンの変更
        }
    }
    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // カメラが利用できるからカメラボタンを追加
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                cameraViewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // フォトライブラリーが使えるならばフォトライブラリーボタンを追加
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")) {
                cameraViewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        // キャンセルボタン
        let cancelButton = ActionSheet.Button.cancel(Text("キャンセル"))
        buttons.append(cancelButton)
        
        let actionSheet = ActionSheet(title: Text("画像選択"), message: nil, buttons: buttons)
        
        return actionSheet
        
    }
//    func savePhoto(image: UIImage) -> String {
//        let a = Date()
//        let filePath = generateFilePath(fileName: "\(a)")
//        if let data = image.pngData() {
//            let url = URL(fileURLWithPath: filePath)
//            try? data.write(to: url)
//        }
//        return filePath
//    }
//    func generateFilePath(fileName: String) -> String {
//        let fileManager = FileManager.default
//        let documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        let filePath = documentsDirectory.appendingPathComponent(fileName).path
//        return filePath
//    }

}


struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(sizeCount: .constant(5), isShowView: .constant(0), isRegistration: .constant(0), itemName: .constant(""), select: .constant(""), itemBrand: .constant(""), imagePath: .constant(""), arrayResult: .constant([0.0]))
    }
}
