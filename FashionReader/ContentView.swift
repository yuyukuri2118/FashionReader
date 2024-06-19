//
//  ContentView.swift
//  FRSample
//
//  Created by cmStudent on 2022/11/30.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        VStack{
            TABView()
        }
    }
}

struct TABView: View {
    @State var selectedTag = 1
    @State var showingModal = false
    @ObservedObject var store = Clothe()
    @ObservedObject var viewModel = ViewModel()
    init() {
        UITabBar.appearance().unselectedItemTintColor = .black
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ZStack{
                    TabView(selection: $selectedTag) {
                        HomeView(selectTab: $selectedTag)
                            .environmentObject(store)
                            .tabItem {
                                Image(systemName: "house")
                                Text("ホーム")
                            }.tag(1)
                        MyDataView()
                            .environmentObject(store)
                            .tabItem {
                                Image(systemName: "tshirt")
                                Text("マイデータ")
                            }.tag(2)
                        ZStack{
                            Rectangle()
                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                        }
                        CompareView()
                            .environmentObject(store)
                            .tabItem {
                                Image(systemName: "arrow.left.arrow.right")
                                Text("比較")
                            }.tag(3)
                        
                        SetttingView()
                            .environmentObject(store)
                            .tabItem {
                                Image(systemName: "gearshape")
                                Text("設定")
                            }.tag(4)
                    }
                    .accentColor(Color("MainColor"))
                    
                    NavigationLink {
                        Registration()
                            .environmentObject(store)
                        //self.showingModal.toggle()
                    } label: {
                        Image(systemName: "camera")
                            .font(.system(size: 23))
                            .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .background(Color("MainColor"))
                            .clipShape(Circle())
                    }
                    .navigationTitle("")
                    .offset(x: 0, y: (geometry.size.height / 2) - 45)
                }
            }
        }
//        .navigationDestination(isPresented: $showingModal) {
//            MeasureView()
//        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//GeometryReader { geometry in
//    HStack{
//        Image(systemName: "house")
//        Image(systemName: "tshirt")
//        Image(systemName: "arrow.left.arrow.right")
//        Image(systemName: "gearshape")
//    }
//}
