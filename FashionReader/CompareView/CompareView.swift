//
//  CompareView.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/01.
//

import SwiftUI
import RealmSwift


struct CompareView: View {
    @State var isSelectClothesLeft = true
    @State var isSelectClothesRight = false
    @State var isResult = false
    @State var isShowMyData = false
    @State var isWriteData = false
    @State var selectRightName = 0
    @State var selectLeftName = 0
    @State var rightItemName = ""
    @State var leftItemName = ""
    @State var rightBrandName = ""
    @State var leftBrandName = ""
    @State var rightCategoryName = ""
    @State var leftCategoryName = ""
    @State var leftImage = Image("dummy")
    @State var rightImage = Image("dummy")
    @State var sizeAL = 0.0
    @State var sizeBL = 0.0
    @State var sizeCL = 0.0
    @State var sizeDL = 0.0
    @State var sizeAR = 0.0
    @State var sizeBR = 0.0
    @State var sizeCR = 0.0
    @State var sizeDR = 0.0
    @State var isCate = true
    @State var select = "トップス"
    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var store: Clothe
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                Button {
                    viewModel.selectRight = false
                    viewModel.selectLeft = true
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                        leftImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .offset(y: -40)
                            .blur(radius: viewModel.selectLeft ? 3.0 : 0.0)
                        Text("\(leftBrandName)")
                            .offset(x: 30, y: 50)
                            .foregroundColor(.gray)
                        Text("\(leftItemName)")
                            .offset(y: 80)
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                        Text(viewModel.selectLeft ? "選択中" : "")
                    }.cornerRadius(20)
                        .overlay(viewModel.selectLeft ?
                                 RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color("MainColor"), lineWidth: 6)
                                 : nil
                        )
                }
                .frame(width: 150, height: 210)
                .position(x: geometry.size.width / 4, y: geometry.size.height / 4)
                .shadow(radius: 6)
                
                
                
                Button {
                    viewModel.selectRight = true
                    viewModel.selectLeft = false
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                        rightImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .offset(y: -40)
                            .blur(radius: viewModel.selectRight ? 3.0 : 0.0)
                        Text("\(rightBrandName)")
                            .offset(x: 30, y: 50)
                            .foregroundColor(.gray)
                        Text("\(rightItemName)")
                            .offset(y: 80)
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                        Text(viewModel.selectRight ? "選択中" : "")
                    }.cornerRadius(20)
                        .overlay(viewModel.selectRight ?
                                 RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color("MainColor"), lineWidth: 6)
                                 : nil
                        )
                }
                .frame(width: 150, height: 210)
                .position(x: geometry.size.width - geometry.size.width / 4, y: geometry.size.height / 4)
                .shadow(radius: 6)
                
                
                VStack{
                    Button {
                        self.isShowMyData.toggle()
                    } label: {
                        Image(systemName: "tshirt")
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .background(Color("MainColor"))
                            .imageScale(.large)
                            .clipShape(Circle())
                            .font(.system(size: 21))
                            .shadow(radius: 10)
                    }
                    Text("マイデータから選ぶ")
                        .font(.callout)
                        .fontWeight(.thin)
                }
                .position(x: geometry.size.width / 4, y: geometry.size.height / 1.8)
                
                VStack{
                    
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.8)
                
                VStack{
                    Button {
                        self.isWriteData.toggle()
                    } label: {
                        Image(systemName: "highlighter")
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .background(viewModel.selectRight ? Color("MainColor") : Color.gray)
                            .imageScale(.large)
                            .clipShape(Circle())
                            .font(.system(size: 21))
                            .shadow(radius: 10)
                    }
                    .disabled(viewModel.selectLeft)
                    Text("入力する")
                        .font(.callout)
                        .fontWeight(.thin)
                }
                .position(x: geometry.size.width - geometry.size.width / 4, y: geometry.size.height / 1.8)
                
                ZStack {
                    NavigationLink {
                        CompareResultView(rightItemName: $rightItemName, leftItemName: $leftItemName,
                                          rightBrandName: $rightBrandName, leftBrandName: $leftBrandName,
                                          rightCategoryName: $rightCategoryName,
                                          sizeAL: $sizeAL,
                                          sizeBL: $sizeBL,
                                          sizeCL: $sizeCL,
                                          sizeDL: $sizeDL,
                                          sizeAR: $sizeAR,
                                          sizeBR: $sizeBR,
                                          sizeCR: $sizeCR,
                                          sizeDR: $sizeDR
                                          )
                            .environmentObject(store)
                    } label: {
                        ZStack {
                            Text("比較する")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                    }
                    .frame(width: geometry.size.width / 3, height: 60)
                    .background(isCate ? Color.gray : Color("MainColor"))
                    .cornerRadius(17)
                    .shadow(radius: isCate ? 0 : 10)
                    .disabled(isCate)
                    
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.3)
                .onChange(of: leftCategoryName) { newValue in
                    if leftCategoryName == rightCategoryName {
                        isCate = false
                    }
                }
                .onChange(of: rightCategoryName) { newValue in
                    if leftCategoryName == rightCategoryName {
                        isCate = false
                    }
                }
                
                
            }.sheet(isPresented: $isShowMyData) {
                if viewModel.selectLeft {
                    CompareLeftMyView(selectLeftName: $selectLeftName,
                                      isShowMyData: $isShowMyData,
                                      leftItemName: $leftItemName,
                                      leftBrandName: $leftBrandName,
                                      leftCategoryName: $leftCategoryName,
                                      sizeA: $sizeAL,
                                      sizeB: $sizeBL,
                                      sizeC: $sizeCL,
                                      sizeD: $sizeDL,
                                      image: $leftImage,
                                      item: clothesData(clothesDB: ClothesDB()),
                                      items: store.items)
                        .environmentObject(store)
                } else if viewModel.selectRight {
                    CompareRightMyView(selectRightName: $selectRightName, isShowMyData: $isShowMyData, rightItemName: $rightItemName, rightBrandName: $rightBrandName,
                                       rightCategoryName: $rightCategoryName,
                                       sizeA: $sizeAR,
                                       sizeB: $sizeBR,
                                       sizeC: $sizeCR,
                                       sizeD: $sizeDR,
                                       image: $leftImage,
                                       item: clothesData(clothesDB: ClothesDB()), items: store.items)
                        .environmentObject(store)
                }
            }
            .sheet(isPresented: $isWriteData) {
                CompareWriteMyView(rightItemName: $rightItemName, rightBrandName: $rightBrandName,
                                   rightCategoryName: $rightCategoryName,
                                   sizeA: $sizeAR,
                                   sizeB: $sizeBR,
                                   sizeC: $sizeCR,
                                   sizeD: $sizeDR,
                                   isWriteMyData: $isWriteData,
                                   select: $select,
                                   item: clothesData(clothesDB: ClothesDB()), items: store.items)
                    .environmentObject(store)
            }
        }
    }
}


struct CompareLeftMyView: View {
    @EnvironmentObject var store: Clothe
    @Binding var selectLeftName: Int
    @Binding var isShowMyData: Bool
    @Binding var leftItemName: String
    @Binding var leftBrandName: String
    @Binding var leftCategoryName: String
    @Binding var sizeA: Double
    @Binding var sizeB: Double
    @Binding var sizeC: Double
    @Binding var sizeD: Double
    @Binding var image: Image
    @ObservedObject var viewModel = ViewModel()
    let item: clothesData
    let items: [clothesData]
    var body: some View {
        List {
            Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "トップス"), id: \.id) { itemm in
                    Button {
                        selectLeftName = itemm.id
                        leftItemName = itemm.itemName
                        leftBrandName = itemm.brandName
                        leftCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()
                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("トップス")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "アウター"), id: \.id) { itemm in
                    Button {
                        selectLeftName = itemm.id
                        leftItemName = itemm.itemName
                        leftBrandName = itemm.brandName
                        leftCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()

                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("アウター")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "ボトム"), id: \.id) { itemm in
                    Button {
                        selectLeftName = itemm.id
                        leftItemName = itemm.itemName
                        leftBrandName = itemm.brandName
                        leftCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()

                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("ボトム")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "バッグ"), id: \.id) { itemm in
                    Button {
                        selectLeftName = itemm.id
                        leftItemName = itemm.itemName
                        leftBrandName = itemm.brandName
                        leftCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()
                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("バッグ")
            }
        }
    }
}

struct CompareRightMyView: View {
    @EnvironmentObject var store: Clothe
    @Binding var selectRightName: Int
    @Binding var isShowMyData: Bool
    @Binding var rightItemName: String
    @Binding var rightBrandName: String
    @Binding var rightCategoryName: String
    @Binding var sizeA: Double
    @Binding var sizeB: Double
    @Binding var sizeC: Double
    @Binding var sizeD: Double
    @Binding var image: Image
    @ObservedObject var viewModel = ViewModel()
    let item: clothesData
    let items: [clothesData]
    var body: some View {
        List {
            Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "トップス"), id: \.id) { itemm in
                    Button {
                        selectRightName = itemm.id
                        rightItemName = itemm.itemName
                        rightBrandName = itemm.brandName
                        rightCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()
                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("トップス")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "アウター"), id: \.id) { itemm in
                    Button {
                        selectRightName = itemm.id
                        rightItemName = itemm.itemName
                        rightBrandName = itemm.brandName
                        rightCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()
                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("アウター")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "ボトム"), id: \.id) { itemm in
                    Button {
                        selectRightName = itemm.id
                        rightItemName = itemm.itemName
                        rightBrandName = itemm.brandName
                        rightCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()

                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("ボトム")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "バッグ"), id: \.id) { itemm in
                    Button {
                        selectRightName = itemm.id
                        rightItemName = itemm.itemName
                        rightBrandName = itemm.brandName
                        rightCategoryName = itemm.categoryName
                        sizeA = itemm.sizeA
                        sizeB = itemm.sizeB
                        sizeC = itemm.sizeC
                        sizeD = itemm.sizeD
                        image = Image(uiImage: viewModel.setImage(imagePath: itemm.imagePath))
                        isShowMyData.toggle()

                    } label: {
                        HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                        }
                    }
                }
            } header: {
                Text("バッグ")
            }
        }
    }
}

struct CompareWriteMyView: View {
    @EnvironmentObject var store: Clothe
    @Binding var rightItemName: String
    @Binding var rightBrandName: String
    @Binding var rightCategoryName: String
    @ObservedObject var viewModel = ViewModel()
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = ""
    @Binding var sizeA: Double
    @Binding var sizeB: Double
    @Binding var sizeC: Double
    @Binding var sizeD: Double
    @Binding var isWriteMyData: Bool
    @Binding var select: String
    let item: clothesData
    let items: [clothesData]
    @State var selectRow: [String] = ["トップス","アウター","ボトム","バッグ"]
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Picker(selection: $select, label: Text("").foregroundColor(.white)) {
                    ForEach(0..<self.selectRow.count) { id in
                        Text(selectRow[id]).tag(0).tag(self.selectRow[id])
                            .foregroundColor(.black)
                    }
                }
                .background(Color("MainColor"))
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: geometry.size.width / 1.2)
                .cornerRadius(10)
                .clipped()
                HStack {
                    Text(select == "トップス" || select == "アウター" ? "肩幅" : select == "ボトム" ? "股上" : "縦")
                    TextField("肩幅", value: $sizeA, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .frame(width: geometry.size.width * 0.8, height: 50)
                HStack {
                    Text(select == "トップス" || select == "アウター" ? "袖丈" : select == "ボトム" ? "股下" : "横")
                    TextField("袖丈", value: $sizeB, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .frame(width: geometry.size.width * 0.8, height: 50)
                if select != "バッグ" {
                    HStack {
                        Text(select == "トップス" || select == "アウター" ? "着丈" : select == "ボトム" ? "パンツ丈" : "")
                        TextField("着丈", value: $sizeC, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    .frame(width: geometry.size.width * 0.8, height: 50)
                }
                if select == "トップス" || select == "アウター" {
                    HStack {
                        Text("身幅")
                        TextField("身幅", value: $sizeD, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    .frame(width: geometry.size.width * 0.8, height: 50)
                }
                // Text with variable declaration
                Button {
                    isWriteMyData.toggle()
                    rightItemName = "入力したデータ"
                    rightBrandName = "\(select)"
                    rightCategoryName = select
                } label: {
                    ZStack {
                        Text("確定")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                }
                .frame(width: geometry.size.width / 3, height: 60)
                .background(Color("MainColor"))
                .cornerRadius(17)
                .shadow(radius: 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CompareResultView: View {
    @State var isShowMyData = false
    @State var selectRightName = 0
    @State var selectLeftName = 0
    @Binding var rightItemName: String
    @Binding var leftItemName: String
    @Binding var rightBrandName: String
    @Binding var leftBrandName: String
    @Binding var rightCategoryName: String
    @Binding var sizeAL: Double
    @Binding var sizeBL: Double
    @Binding var sizeCL: Double
    @Binding var sizeDL: Double
    @Binding var sizeAR: Double
    @Binding var sizeBR: Double
    @Binding var sizeCR: Double
    @Binding var sizeDR: Double
    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var store: Clothe
    var body: some View {
        GeometryReader { geometry in
            Group {
                
                Text("\(leftItemName)")
                    .font(.title)
                    .foregroundColor(Color("MainColor"))
                    .position(x: geometry.size.width / 4, y: geometry.size.height / 8)
                Text("\(leftBrandName)")
                    .position(x: geometry.size.width / 4, y: geometry.size.height / 6)
                Text("\(rightItemName)")
                    .font(.title)
                    .foregroundColor(Color("MainColor"))
                    .position(x: geometry.size.width / 1.5, y: geometry.size.height / 8)
                Text("\(rightBrandName)")
                    .position(x: geometry.size.width / 1.5, y: geometry.size.height / 6)
                Group {
                    HStack {
                        Text("\(String(format: "%.2f",sizeAL))cm")
                            .offset(x: -30)
                        VStack {
                            Text(rightCategoryName == "トップス" || rightCategoryName == "アウター" ? "肩幅" : rightCategoryName == "ボトム" ? "股上" : "縦")
                            Text("\(String(format: "%.2f",sizeAL - sizeAR))cm")
                                .foregroundColor(sizeAL >= sizeAR ? Color.red.opacity(0.8) :
                                                                    Color.blue.opacity(0.8))
                        }
                            .foregroundColor(Color("MainColor"))
                        Text("\(String(format: "%.2f",sizeAR))cm")
                            .offset(x: 30)
                        
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 3)
                    HStack {
                        Text("\(String(format: "%.2f",sizeBL))cm")
                            .offset(x: -30)
                        VStack {
                            Text(rightCategoryName == "トップス" || rightCategoryName == "アウター" ? "袖丈" : rightCategoryName == "ボトム" ? "股下" : "横")
                            Text("\(String(format: "%.2f",sizeBL - sizeBR))cm")
                                .foregroundColor(sizeBL >= sizeBR ? Color.red.opacity(0.8) :
                                                                    Color.blue.opacity(0.8))
                        }
                            .foregroundColor(Color("MainColor"))
                        Text("\(String(format: "%.2f",sizeBR))cm")
                            .offset(x: 30)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    if rightCategoryName != "バッグ" {
                        HStack {
                            Text("\(String(format: "%.2f",sizeCL))cm")
                                .offset(x: -30)
                            VStack {
                                Text(rightCategoryName == "トップス" || rightCategoryName == "アウター" ? "着丈" : rightCategoryName == "ボトム" ? "パンツ丈" : "")
                                Text("\(String(format: "%.2f",sizeCL - sizeCR))cm")
                                    .foregroundColor(sizeCL >= sizeCR ? Color.red.opacity(0.8) :
                                                                        Color.blue.opacity(0.8))
                            }
                                .foregroundColor(Color("MainColor"))
                            Text("\(String(format: "%.2f",sizeCR))cm")
                                .offset(x: 30)
                        }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
                    }
                    if rightCategoryName == "トップス" || rightCategoryName == "アウター" {
                        HStack {
                            Text("\(String(format: "%.2f",sizeDL))cm")
                                .offset(x: -30)
                            VStack {
                                Text("身幅")
                                Text("\(String(format: "%.2f",sizeDL - sizeDR))cm")
                                    .foregroundColor(sizeDL >= sizeDR ? Color.red.opacity(0.8) :
                                                                        Color.blue.opacity(0.8))
                            }
                                .foregroundColor(Color("MainColor"))
                            Text("\(String(format: "%.2f",sizeDR))cm")
                                .offset(x: 30)
                        }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 1.2)
                    }
                }
                .offset(x: -geometry.size.width / 19)
                .font(.title2)
                
            }
            .frame(width: geometry.size.width / 1.08, height: geometry.size.height / 1.1)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .font(.caption)
            .foregroundColor(.black.opacity(0.8))
        }
    }
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView()
    }
}
