//
//  SearchView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/30.
//

import SwiftUI

struct SearchView: View{
    @State private var searchText = ""
    @Binding var index1: Int
    @State private var navigateToLowCarbon = true
    @State private var navigateToSiteInfo = false
    @State private var showres = false
    @State private var showaccom = false
    @StateObject private var mapViewModel = MapViewModel()
    
   
    var body: some View{
        NavigationView  {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                }
                .frame(height:40)
                .frame(maxWidth: .infinity)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                // Search bar
                HStack {
                    // Search icon
                    Image(systemName: "magnifyingglass")
                        .frame(width: 45, height: 45)
                        .padding(.leading, 10)
                    
                    // Text field
                    TextField("搜尋地點", text: $searchText)
                        .font(.system(size: 15))
                        .onChange(of: searchText) { newValue in
                            mapViewModel.searchPlaces(query: newValue)
                        }
                        .padding(.vertical, 10)
                }
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding()
                
                // Button section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        categoryButton(title: "低碳", systemName: "carbon.dioxide.cloud.fill", index: 4)
                        categoryButton(title: "附近", systemName: "mappin.and.ellipse", index: 0)
                        categoryButton(title: "餐廳", systemName: "fork.knife", index: 1)
                        categoryButton(title: "住宿", systemName: "bed.double.fill", index: 2)
                        categoryButton(title: "超市", systemName: "cart.fill", index: 3)
                    }
                    .padding(.horizontal)
                }
                
                if navigateToLowCarbon {
                    LowCarbonListView()
                } else if mapViewModel.isLoading {
                    ProgressView("正在載入地點...")
                        .font(.system(size: 15))
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))
                        .padding()
                } else if mapViewModel.searchResults.isEmpty {
                    Text("沒有找到地點")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                        .padding()
                } else {
                    ScrollView {
                        ForEach(mapViewModel.searchResults) { placeModel in
                            placeCard(placeModel: placeModel)
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            index1 = 4 // Default to "低碳"
        }
    }
    private func categoryButton(title: String, systemName: String, index: Int) -> some View {
        Button(action: {
            self.index1 = index
            if index == 4 {
                navigateToLowCarbon = true
            }else{
                navigateToLowCarbon = false
                switch index {
                case 0:
                    mapViewModel.searchNearbyPlaces()
                case 1:
                    mapViewModel.searchPlaces(query: "餐廳")
                case 2:
                    mapViewModel.searchPlaces(query: "住宿")
                case 3:
                    mapViewModel.searchPlaces(query: "超市")
                default:
                    break
                }
            }}) {
            HStack {
                Image(systemName: systemName)
                    .foregroundColor(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0))
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0))
            }
            .frame(width: 80, height: 35)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
            )
        }
        .padding(.horizontal, 5)
    }
    
    // Helper function to display place card
    func placeCard(placeModel: PlaceModel) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment:.top) {
                HStack {
                    // Display lowCarbon icon if the place is low-carbon
                    if false {
                        ZStack {
                            Circle()  // 白色圓形背景
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "leaf.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                        }
                        .padding(10)
                    }
                    Spacer()
                    
                    // Heart button for favoriting a place
                    Button(action: {
                        // TODO: favorite
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .padding(5)
                            
                            Image(systemName:"heart")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    })
                }
                .frame(width: 280, height: 60)
                .zIndex(1)
                
                // Place image with NavigationLink to SiteInfoView
                NavigationLink(destination: SiteInfoView(placeModel: placeModel)) {
                    if let image = placeModel.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 130)
                            .clipped()
                    }
                }
            }
            
            HStack(spacing:0) {
                VStack(alignment: .leading) {
                    Text(placeModel.name)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text(placeModel.address)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 15)
                        .frame(maxWidth: 200)
                }
                Spacer()
                
                Button(action: {
                    // 按鈕動作
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 15)

                }
            }
            .frame(width: 280, height: 60, alignment: .leading)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(20)
    }
}
