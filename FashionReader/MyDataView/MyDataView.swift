//
//  MyDataView.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/01.
//

import SwiftUI
import RealmSwift


struct MyDataView: View {
    @State var keyword = ""
    @State var selectRow: [String] = ["新しい順","古い順","五十音順"]
    @State var select: String = "新しい順"
    @State var selectCategory = "全て"
    @State var isFavorite = false
    @State var isAll = true
    @State var isTops = false
    @State var isOuter = false
    @State var isBottom = false
    @State var isBag = false
    @State var isWrite = false
    @EnvironmentObject var store: Clothe
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ZStack{
                    ClothingDataView(select: $select, item: clothesData(clothesDB: ClothesDB()), items: store.items, isAll: $isAll, isTops: $isTops, isOuter: $isOuter, isBottoms: $isBottom, isBag: $isBag, isWrite: $isWrite, selectCategory: $selectCategory, word: $keyword
                    )
                        .environmentObject(store)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height)
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: 250)
                        .foregroundColor(Color("MainColor"))
                    
                    
                    TextField("🔍キーワードを入力", text: $keyword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: geometry.size.width - 60)
                        .shadow(radius: 10)
                    Button {
                        //store.create(brandName: "ダミー", itemName: "ダミー", categoryName: "ダミー", itemToggle: false)
                        keyword = ""
                    } label: {
                        Image(systemName:  "xmark")
                            .frame(width: 30, height: 30)
                    }.offset(x: geometry.size.width / 2 - 45)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(0 ..< 100) {_ in
                                SerchTabButton(isAll: $isAll, isTops: $isTops, isOuter: $isOuter, isBottoms: $isBottom, isBag: $isBag, isWrite: $isWrite, selectCategory: $selectCategory)
                                    .environmentObject(store)
                            }
                        }
                    }.offset(y:50)
                    
//                    Toggle(isOn: $isFavorite) {
//                        Text("お気に入りを優先")
//                            .font(.system(.body, design: .rounded))
//                            .fontWeight(.regular)
//                            .foregroundColor(.white)
//                    }
//                    .toggleStyle(CheckboxStyle())
//                    .offset(x: -geometry.size.width / 4, y: 100)
//                    
                    ZStack {
                        Rectangle()
                            .frame(width: 100, height: 35)
                            .foregroundColor(.white)
                            .cornerRadius(10).shadow(radius: 10)
                        Picker(selection: self.$select, label: Text("")) {
                            ForEach(0..<self.selectRow.count) { id in
                                Text(selectRow[id]).tag(0).tag(self.selectRow[id])
                            }
                        }
                    }.offset(x: geometry.size.width / 3.5, y: 100)
                }.position(x: geometry.size.width / 2, y: 25)
            }
        }
    }
}


struct SerchTabButton: View {
    @Binding var isAll: Bool
    @Binding var isTops: Bool
    @Binding var isOuter: Bool
    @Binding var isBottoms: Bool
    @Binding var isBag: Bool
    @Binding var isWrite: Bool
    @Binding var selectCategory: String
    @EnvironmentObject var store: Clothe
    var body: some View{
        Button {
            isAll.toggle()
            isTops = false
            isOuter = false
            isBottoms = false
            isBag = false
            isWrite = false
            selectCategory = "全て"
        } label: {
            Text("全て")
                .foregroundColor(.white)
                .frame(width: 90, height: 40)
                .fontWeight(isAll ? .semibold : .regular)
        }
        
        Button {
            isTops.toggle()
            isAll = false
            isOuter = false
            isBottoms = false
            isBag = false
            isWrite = false
            selectCategory = "トップス"
        } label: {
            Text("トップス")
                .foregroundColor(.white)
                .frame(width: 90, height: 40)
                .fontWeight(isTops ? .heavy : .regular)
        }
        Button {
            isOuter.toggle()
            isAll = false
            isTops = false
            isBottoms = false
            isBag = false
            isWrite = false
            selectCategory = "アウター"
        } label: {
            Text("アウター")
                .foregroundColor(.white)
                .frame(width: 90, height: 40)
                .fontWeight(isOuter ? .heavy : .regular)
        }
        Button {
            isBottoms = true
            isAll = false
            isOuter = false
            isTops = false
            isBag = false
            isWrite = false
            selectCategory = "ボトム"
        } label: {
            Text("ボトム")
                .foregroundColor(.white)
                .frame(width: 90, height: 40)
                .fontWeight(isBottoms ? .heavy : .regular)
        }
        
        Button {
            isBag.toggle()
            isAll = false
            isOuter = false
            isBottoms = false
            isTops = false
            isWrite = false
            selectCategory = "バッグ"
        } label: {
            Text("バッグ")
                .foregroundColor(.white)
                .frame(width: 90, height: 40)
                .fontWeight(isBag ? .heavy : .regular)
        }
    }
}

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // チェックボックスの外観と動作を返す
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" :
                    "square")
            .foregroundColor(configuration.isOn ? .orange : .white)
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            configuration.label
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}


struct MyDataView_Previews: PreviewProvider {
    static var previews: some View {
        MyDataView()
    }
}
