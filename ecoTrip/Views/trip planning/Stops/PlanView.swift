//
//  PlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/1.
//

import SwiftUI
import GoogleMaps

struct PlanView: View {
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedDayIndex = 0
    @State private var showNewStop = false
    @State private var showDemo = false
    @State private var showChatView = false
    @State private var isFirstAppear = true
    @State private var navigationPath = NavigationPath()
    @State private var showEditPlan = false
    @State private var hasExistingSchedule: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var showMapView = false
    @EnvironmentObject var transportationViewModel: TransportationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with back button and other controls
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                    })
                    .padding(.horizontal)
                    .padding(.bottom,5)
                    
                    Button(action: {
                        
                    }, label: {
                        Image("agent")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .cornerRadius(20)
                        
                    })
                    .opacity(0)
                    .padding(.trailing,10)
                    
                    Spacer()
                    
                    Text(travelPlanViewModel.selectedTravelPlan!.planname)
                        .foregroundStyle((.white))
                        .font(.system(size: 20))
                        .bold()
                        .padding(.bottom,5)
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    // 地圖 button
                    Button(action: {
                        
                        showMapView.toggle()
                    }, label: {
                        
                        Image(systemName: "map.fill")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 25, height: 25)
                        
                        
                    })
                    .padding(.trailing,5)
                    .padding(.bottom,5)
                    .sheet(isPresented: $showMapView) {
                        if let dayStops = travelPlanViewModel.dayStops, !dayStops.stops.isEmpty {
                            MapView(stops: dayStops.stops)
                            
                        }
                        
                    }
                    
                    Button(action: {
                        showChatView.toggle()
                    }, label: {
                        Image("agent")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(20)
                        
                    })
                    .padding(.trailing,10)
                    .padding(.bottom,5)
                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height:50)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                // Days section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(Array(travelPlanViewModel.days.enumerated()), id: \.element.id) { index, day in
                            Button(action: {
                                selectedDayIndex = index
                                selectedDate = dateFromString(day.date) ?? Date()
                                if let token = authViewModel.accessToken {
                                    travelPlanViewModel.fetchStopsForDay(dayId: day.id, token: token)
                                }
                            }) {
                                Text(formatDate(day.date))
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedDayIndex == index ? .black : .white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(selectedDayIndex == index ? .white : Color.init(hex: "8F785C", alpha: 1.0))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
                .padding(.bottom)
                
                // Content based on selected day
                if travelPlanViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))
                    
                } else if let error = travelPlanViewModel.error {
                    Text("Error: \(error)")
                } else if let dayStops = travelPlanViewModel.dayStops, !dayStops.stops.isEmpty {
                    StopListView(stops: dayStops.stops, reloadData: reloadData, accessToken: authViewModel.accessToken!)
                        .onAppear { hasExistingSchedule = true }
                        .environmentObject(travelPlanViewModel)
                        .environmentObject(transportationViewModel) 
                    
                } else {
                    Text("No plans for this day yet.")
                        .foregroundColor(.gray)
                        .onAppear { hasExistingSchedule = false }
                }
                
                Spacer()
                
                // Add new plan button
                Button(action: {
                    showNewStop.toggle()
                }) {
                    Text("新增行程")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // 隱藏返回按鈕
        .popupNavigationView(horizontalPadding: 40, show: $showDemo) {
            Demo(showDemo: $showDemo)
        }
        .sheet(isPresented: $showNewStop) {
            NewStopView(showNewStop: $showNewStop, hasExistingSchedule: hasExistingSchedule, reloadData: reloadData, selectedDate: selectedDate)
                .presentationDetents([.height(650)])
                .environmentObject(travelPlanViewModel)
                .environmentObject(authViewModel)
            
        }
        .sheet(isPresented: $showChatView) {
            ChatView()
        }
        .onAppear {
            if let selectedPlan = travelPlanViewModel.selectedTravelPlan,
               let token = authViewModel.accessToken {
                travelPlanViewModel.fetchDaysForPlan(planId: selectedPlan.id, token: token) {
                    if let firstDay = travelPlanViewModel.days.first {
                        selectedDate = dateFromString(firstDay.date) ?? Date()
                        travelPlanViewModel.fetchStopsForDay(dayId: firstDay.id, token: token)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M/d"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    private func formatTime(_ timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        }
        return timeString
    }
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // 使用 GMT
        
        return formatter.date(from: dateString)
    }
    func reloadData() {
        if let token = authViewModel.accessToken {
            travelPlanViewModel.fetchStopsForDay(dayId: travelPlanViewModel.days[selectedDayIndex].id, token: token)
        }
    }
}
