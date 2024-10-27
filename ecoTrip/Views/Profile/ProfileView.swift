//
//  ProfileView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var userViewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedIcon: IconType = .suitcase

    enum IconType: String {
        case suitcase, leaf, heart
    }

    var body: some View {
        VStack {
            HStack {
                
                Spacer()
             
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            HStack {
                Image("bulldog")
                     .resizable()
                     .scaledToFill()
                     .frame(width: 70, height: 70)
                     .clipShape(Circle())
                     .padding()
                   
            
                   
             
                if userViewModel.isLoading {
                    ProgressView()
                } else if let error = userViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                } else if let user = userViewModel.user {
                    Text(user.username)
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                } else {
                    Text("User not found")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)



            HStack(spacing: 0) {
                IconView(icon: .suitcase, isSelected: selectedIcon == .suitcase) {
                    selectedIcon = .suitcase
                }
                IconView(icon: .leaf, isSelected: selectedIcon == .leaf) {
                    selectedIcon = .leaf
                }
                IconView(icon: .heart, isSelected: selectedIcon == .heart) {
                    selectedIcon = .heart
                }
            }
            // Displaying the appropriate view based on the selected icon
           Group {
               if selectedIcon == .suitcase {
                   SuitcaseView()
               } else if selectedIcon == .leaf {
                   LeafView(userViewModel: userViewModel)
               } else if selectedIcon == .heart {
                   HeartView()
               }
           }
            Spacer()
        }
        .onAppear {
            if let token = authViewModel.accessToken {
                userViewModel.fetchUserInfo(token: token)
            }
        }

    }
}

struct IconView: View {
    let icon: ProfileView.IconType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack {
            Button(action: action) {
                Image(systemName: iconName(for: icon))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .padding()
            }
            Rectangle()
                .frame(width: 130, height: 5)
                .foregroundColor(isSelected ? Color(hex: "5E845B", alpha: 1.0) : Color(hex: "D1CECE", alpha: 1.0))
                .padding(.bottom)
        }
    }

    private func iconName(for type: ProfileView.IconType) -> String {
        switch type {
        case .suitcase:
            return "suitcase"
        case .leaf:
            return "leaf"
        case .heart:
            return "heart"
        }
    }
}
