//
//  LeafView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//

import SwiftUI

struct LeafView: View {
    @State private var ecoPercentage: CGFloat = 80
    @State private var piePercentage1: CGFloat = 83
    @State private var piePercentage2: CGFloat = 68
    @State private var progressBarPercentage: CGFloat = 42

    var body: some View {
        VStack(alignment:.center) {
            Text("您的環保程度已超越\(Int(ecoPercentage))%用戶！")
                .bold()
                .font(.system(size: 23))
            Spacer()
                .frame(height:60)
            
            HStack(spacing:30){
                VStack{
                    PieChart(percentage: piePercentage1)
                        .frame(width: 120, height: 120)
                    Text("選擇大眾運輸比例")
                        .bold()
                        .font(.system(size: 18))
                        .padding(.vertical)
                    
                    
                }
                
                VStack{
                    PieChart(percentage: piePercentage2)
                        .frame(width: 120, height: 120)
                    Text("選擇綠色景點比例")
                        .bold()
                        .font(.system(size: 18))
                        .padding(.vertical)
                }
            }
            
            Spacer()
                .frame(height:40)
            
            
            ProgressBar(percentage: progressBarPercentage)
                .frame(width: 300, height: 20) // Adjust size as needed
            
            Text("規劃的行程所降低的碳排放量")
                .bold()
                .font(.system(size: 18))
                .padding(.top)
        }
    }
}
struct PieChart: View {
    var percentage: CGFloat
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
              .stroke(Color.gray.opacity(0.3), lineWidth: 20) // Light gray background
                          
            Circle()
                .trim(from: 0.0, to: percentage / 100)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: percentage)
            
            Text("\(Int(percentage))%")
                .font(.system(size: 20))
                .bold()
        }
    }
}
struct ProgressBar: View {
    var percentage: CGFloat
    
    var body: some View {
        HStack{
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 20)
                    
                    Rectangle()
                        .foregroundColor(Color.green)
                        .frame(width: geometry.size.width * (percentage / 100), height: 20)
                        .animation(.linear, value: percentage)
                    
                }
                .cornerRadius(10)
                
            }
          Text("\(Int(percentage))%")
              .font(.system(size: 20))
              .bold()
              .padding(.leading, 5)  // Space between the bar and the text
        }
    }
}


#Preview {
    LeafView()
}
