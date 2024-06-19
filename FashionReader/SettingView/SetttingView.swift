//
//  SetttingView.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/01.
//

import SwiftUI

struct SetttingView: View {
    @State var isNotice = true
    @State var isAlertSelectDelete = false
    @State var isAlertAllDelete = false
    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var store: Clothe
    var body: some View {
        VStack{
            NavigationView{
                List{
                    Section(header: Text("通知設定")) {
                        HStack{
                            Text("通知")
                            Image(systemName: isNotice ? "bell" : "bell.slash")
                            Toggle(isOn: $isNotice) {
                            }
                                .toggleStyle(SwitchToggleStyle(tint: Color("MainColor")))
                                .onChange(of: isNotice) { newValue in
                                    if newValue {
                                        viewModel.isOn = true
                                    } else {
                                        viewModel.isOn = false
                                        viewModel.makeNotification(isOn: newValue)
                                    }
                                }
                        }
                    }
                    Section(header: Text("データ管理")) {
                        NavigationLink(destination: SelectDeleteView(item: clothesData(clothesDB: ClothesDB()), items: store.items)
                            .environmentObject(store)) {
                            VStack{
                                Text("削除したい項目を選ぶ")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        Button {
                            isAlertAllDelete = true
                        } label: {
                            Text("全データ削除")
                        }
                    }
                    Section(header: Text("データ管理")) {
                    }
                }.navigationTitle("設定")
            }
            .alert(isPresented: $isAlertAllDelete) {
                Alert(title: Text("データを全消去しますがよろしいですか？"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .destructive(Text("削除"),
                                                    action: {
                    store.deleteAll()
                }))
            }
        }
    }
}

struct SelectDeleteView: View {
    @EnvironmentObject var store: Clothe
    @ObservedObject var viewModel = ViewModel()
    let item: clothesData
    let items: [clothesData]
    @Environment(\.presentationMode) var presentation
    @State var selectRow: [String] = ["トップス","アウター","ボトム","バッグ"]
    var body: some View {
        List {
            Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "トップス"), id: \.id) { itemm in
                    
                    HStack {
                        Text("\(itemm.itemName)")
                            .foregroundColor(Color("MainColor"))
                        Text("\(itemm.brandName)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.black)
                    }
                    .swipeActions(edge: .trailing) {
                        Button() {
                            store.delete(itemID: itemm.id)
                            print("delete")
                        } label: {
                            Image(systemName: "trash.fill")
                            
                        }.foregroundColor(Color("MainColor"))
                    }
                }
            } header: {
                Text("トップス")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "アウター"), id: \.id) { itemm in
                    
                    HStack {
                        Text("\(itemm.itemName)")
                            .foregroundColor(Color("MainColor"))
                        Text("\(itemm.brandName)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.black)
                    }
                    .swipeActions(edge: .trailing) {
                        Button() {
                            store.delete(itemID: itemm.id)
                            print("delete")
                        } label: {
                            Image(systemName: "trash.fill")
                            
                        }.foregroundColor(Color("MainColor"))
                    }
                }
            } header: {
                Text("アウター")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "ボトム"), id: \.id) { itemm in
                    
                    HStack {
                        Text("\(itemm.itemName)")
                            .foregroundColor(Color("MainColor"))
                        Text("\(itemm.brandName)")
                            .frame(alignment: .trailing)
                            .foregroundColor(.black)
                    }
                    .swipeActions(edge: .trailing) {
                        Button() {
                            store.delete(itemID: itemm.id)
                            print("delete")
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color("MainColor"))
                        }
                    }
                }
            } header: {
                Text("ボトム")
            }; Section {
                ForEach(store.getSortedClothes(word: "", sort: "", categoryName: "バッグ"), id: \.id) { itemm in
                    HStack {
                            Text("\(itemm.itemName)")
                                .foregroundColor(Color("MainColor"))
                            Text("\(itemm.brandName)")
                                .frame(alignment: .trailing)
                                .foregroundColor(.black)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            store.delete(itemID: itemm.id)
                            print("delete")
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color("MainColor"))
                        }
                    }
                }
            } header: {
                Text("バッグ")
            }
        }
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("MainColor"))
                        Text("戻る")
                            .foregroundColor(Color("MainColor"))
                    }
                }
            }
        }
    }
}

struct SetttingView_Previews: PreviewProvider {
    static var previews: some View {
        SetttingView()
    }
}
