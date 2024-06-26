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
    @FocusState private var focus: Bool
    @Binding var index1: Int
    
    
    
    var body: some View{
 
            VStack(alignment: .center) {
                
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
                        .focused($focus)
                        .padding(.vertical, 10)
                    
                    // Filter icon
                    Button(action: {}, label: {
                        Image(.filter)
                            .frame(width: 45, height: 45)
                            .padding(.trailing, 10)
                    })
                }
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding(10)
                .onAppear {
                    focus = true
                    placeViewModel.fetchPlaces() // Fetch places when the view appears
                }
                
                // Button section
                HStack {
                    // 附近 button
                    Button(action: {
                        self.index1 = 0
                        
                    }, label: {
                        HStack {
                            Image(systemName:"mappin.and.ellipse")
                                .foregroundColor(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                .frame(width: 21, height: 21)
                            Text("附近")
                                .foregroundColor(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0))
                            
                        }
                        .padding(10)
                        .frame(width: 90, height: 41)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(index1 == 0 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                        )
                    })
                    .padding(.horizontal, 5)
                    
                    // 餐廳 button
                    Button(action: {
                        self.index1 = 1
                    }, label: {
                        HStack {
                            Image(systemName: "fork.knife")
                                .foregroundColor(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                .frame(width: 21, height: 21)
                            Text("餐廳")
                                .foregroundColor(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0))
                        }
                        .padding(10)
                        .frame(width: 90, height: 41)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(index1 == 1 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                        )
                    })
                    .padding(.horizontal, 5)
                    
                    // 住宿 button
                    Button(action: {
                        self.index1 = 2
                        
                    }, label: {
                        HStack {
                            Image(systemName: "bed.double.fill")
                                .foregroundColor(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0))
                                .frame(width: 21, height: 21)
                            Text("住宿")
                                .foregroundColor(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0))
                        }
                        .padding(10)
                        .frame(width: 90, height: 41)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(index1 == 2 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                        )
                    })
                    .padding(.horizontal, 5)
                }
                .padding(10)
                
                // Display places
                ScrollView {
                    ForEach(placeViewModel.places) { place in
                        VStack(spacing: 0) {
                            ZStack(alignment: .topLeading) {
                                Button(action: {
                                    // 按鈕動作
                                }) {
                                    if place.lowCarbon {
                                        Image(.greenlabel2)
                                            .resizable()
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .zIndex(1)
                                    }
                                }
                                .zIndex(1)
                                
                                AsyncImage(url: URL(string: place.image)) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 320, height: 150)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Color.red // Indicates an error.
                                            .frame(width: 320, height: 150)
                                    } else {
                                        Color.gray // Acts as a placeholder.
                                            .frame(width: 320, height: 150)
                                    }
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(place.placename).bold()
                                        .font(.title2)
                                        .padding(.top, 10)
                                        .padding(.leading, 10)
                                        .padding(.bottom, 5)
                                    
                                    Text(place.address)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 10)
                                        .padding(.bottom, 10)
                                }
                                
                                Spacer()
                                    .frame(minWidth: 30, maxWidth: 70)
                                Button(action: {
                                    // 按鈕動作
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.black)
                                        .padding(10)
                                }
                            }
                            .frame(width: 320, height: 80, alignment: .leading)
                            .background(Color.white)
                        }
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(20)
                    }
                }
                
       
            }

        }
    }

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(index1: .constant(0))
    }
}
