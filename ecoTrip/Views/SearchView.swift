//
//  SearchView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/30.
//

import SwiftUI

struct SearchView: View{
    @StateObject private var placeViewModel = PlaceViewModel()
    @State private var textInput = ""
    @Binding var index1: Int
    @State private var navigateToSiteInfo = false
    @State private var showres = false
    @State private var showaccom = false
    
    var body: some View{
        NavigationView  {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                // Search bar
                HStack {
                    // Search icon
                    Image(systemName: "magnifyingglass")
                        .frame(width: 45, height: 45)
                        .padding(.leading, 10)
                    
                    // Text field
                    TextField(" ", text: $textInput)
                        .onSubmit {
                            print(textInput)
                        }
                        .padding(.vertical, 10)
                }
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding()
                .onAppear {
                    placeViewModel.fetchPlaces() // Fetch places when the view appears
                }
                
                // Button section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // 附近 button
                        Button(action: {
                            self.index1 = 0
                        }, label: {
                            HStack {
                                Image(systemName:"mappin.and.ellipse")
                                    .foregroundColor(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                    .frame(width: 20, height: 20)
                                Text("附近")
                                    .font(.system(size: 15))
                                    .foregroundColor(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0))
                            }
                            .frame(width: 80, height: 35)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                            )
                        })
                        .padding(.horizontal,10)
                        
                        // 餐廳 button
                        Button(action: {
                            self.index1 = 1
                        }, label: {
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                    .frame(width: 20, height: 20)
                                Text("餐廳")
                                    .font(.system(size: 15))
                                    .foregroundColor(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0))
                            }
                            .frame(width: 80, height: 35)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                            )
                        })
                        .padding(.trailing,10)
                        
                        // 住宿 button
                        Button(action: {
                            self.index1 = 2
                        }, label: {
                            HStack {
                                Image(systemName: "bed.double.fill")
                                    .foregroundColor(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                    .frame(width: 20, height: 20)
                                Text("住宿")
                                    .font(.system(size: 15))
                                    .foregroundColor(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0))
                            }
                            .frame(width: 80, height: 35)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                            )
                        })
                        .padding(.trailing,10)
                        
                        
                        // 超市 button
                        Button(action: {
                            self.index1 = 3
                        }, label: {
                            HStack {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(index1 == 3 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                    .frame(width: 20, height: 20)
                                Text("超市")
                                    .font(.system(size: 15))
                                    .foregroundColor(index1 == 3 ? .black : Color.init(hex: "999999", alpha: 1.0))
                            }
                            .frame(width: 80, height: 35)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(index1 == 3 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                            )
                        })
                    }
                    .padding(.horizontal)
                    
                }
                
                
                // Display places based on selected index
                ScrollView {
                    if index1 == 0 {
                        // Display all places
                        ForEach(placeViewModel.places) { place in
                            placeCard(place: place)
                        }
                    } else if index1 == 1 {
                        // Display restaurants
                        //                        ForEach(placeViewModel.restaurants) { place in
                        //                            placeCard(place: place)
                        //                        }
                    } else if index1 == 2 {
                        // Display accommodations
                        //                        ForEach(placeViewModel.accommodations) { place in
                        //                            placeCard(place: place)
                        //                        }
                    } else if index1 == 3 {
                        // Display supermarkets
                        //                        ForEach(placeViewModel.supermarkets) { place in
                        //                            placeCard(place: place)
                        //                        }
                    }
                }
            }
        }
    }
    
    // Helper function to display place card
    func placeCard(place: Place) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment:.top) {
                HStack {
                    // Display lowCarbon icon if the place is low-carbon
                    if place.lowCarbon {
                        Image(.greenlabel2)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    Spacer()
                    
                    // Heart button for favoriting a place
                    Button(action: {
                        placeViewModel.toggleFavorite(for: place.id)
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .padding(5)
                            
                            Image(systemName: placeViewModel.favorites[place.id, default: false] ? "heart.fill" : "heart")
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
                NavigationLink(destination: SiteInfoView( place: place)) {
                    AsyncImage(url: URL(string: place.image)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 280, height: 130)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red // Indicates an error.
                                .frame(width: 280, height: 130)
                        } else {
                            Color.gray // Acts as a placeholder.
                                .frame(width: 280, height: 130)
                        }
                    }
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(place.placename)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text(place.address)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 15)
                }
                
                Button(action: {
                    // 按鈕動作
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(.leading, 25)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(index1: .constant(0))
    }
}
