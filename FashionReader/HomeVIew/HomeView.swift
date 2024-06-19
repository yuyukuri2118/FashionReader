//
//  HomeView.swift
//  FRSample
//
//  Created by cmStudent on 2022/12/01.
//

import UserNotifications
import SwiftUI

struct HomeView: View {
    @State var isShowRegistration = false
    @ObservedObject var viewModel = ViewModel()
    @Binding var selectTab: Int
    //@EnvironmentObject var store: Clothe
    @EnvironmentObject var store: Clothe
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        //let sortedClothes = store.getSortedClothes(word: word, sort: select, categoryName: selectCategory)
        GeometryReader { geometry in
            ZStack{
                NavigationStack {
                    VStack{
                        HStack{
                            VStack{
                                NavigationLink {
                                    Registration()
                                        .environmentObject(store)
                                    
                                } label: {
                                    Image(systemName: "camera")
                                        .font(.system(size: 23))
                                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                        .imageScale(.large)
                                        .foregroundColor(.white)
                                        .background(Color("MainColor"))
                                        .clipShape(Circle())
                                }
                                .shadow(radius: 8)
                                
                                Text("登録する")
                                    .font(.title2)
                                    .fontWeight(.light)
                            }.offset(x: -geometry.size.width / 9, y: 10)
                            
                            VStack{
                                Button {
                                    selectTab = 3
                                    
                                } label: {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.system(size: 23))
                                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                        .imageScale(.large)
                                        .foregroundColor(.white)
                                        .background(Color("MainColor"))
                                        .clipShape(Circle())
                                }
                                .shadow(radius: 8)
                                Text("比較する")
                                    .font(.title2)
                                    .fontWeight(.light)
                            }.offset(x: geometry.size.width / 9, y: 10)
                        }
                        .frame(height: 150)
                        .offset(y: 30)
                        
                        
                        Divider()
                            .offset(y: 50)
                        
                        Text("最近の項目")
                            .frame(width: geometry.size.width / 1.2, alignment: .leading)
                            .font(.largeTitle)
                            .fontWeight(.thin)
                            .offset(y: 50)
                        
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(store.items, id: \.id) { item in
                                    ZStack{
                                        Image(uiImage: viewModel.setImage(imagePath: item.imagePath))
                                            .resizable()
                                            .scaledToFill() // ここに移動
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.height / 4 ,height: geometry.size.height / 4)
                                            .clipped()
                                            .cornerRadius(20)
                                            .offset(y: -40)
                                            .blur(radius: viewModel.selectRight ? 3.0 : 0.0)
                                        
                                        Text("\(item.brandName)")
                                            .offset(x: 30, y: 50)
                                            .foregroundColor(.gray)
                                        Text("\(item.itemName)")
                                            .offset(y: 80)
                                            .font(.title2)
                                            .foregroundColor(.black.opacity(0.8))
                                    }
                                    .frame(width: geometry.size.height / 4 ,height: geometry.size.height / 3)
                                    .background(.white)
                                    .cornerRadius(20)
                                    .shadow(color: .gray.opacity(0.7), radius: 5)
                                    .foregroundColor(.white)
                                }
                                
                            }
                            .frame(height: geometry.size.height / 2.5)
                        }
                        .frame(height: geometry.size.height / 2.5)
                        .offset(y: 50)
                    }
                    
                }
            }
            Rectangle()
                .ignoresSafeArea()
                .frame(width: geometry.size.width * 2, height: 15)
                .foregroundColor(Color("MainColor"))
                .position()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectTab: .constant(0))
    }
}
