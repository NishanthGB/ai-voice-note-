//
//  ProgressViewUI.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct ProgressViewUI: View {
    @State var homeViewModel : HomeView.HomeViewModel
    var body: some View {
        VStack{
                Spacer()
            VStack(spacing: 50){
                    ProgressView()
                      .tint(.gray)
                    
                    Text(homeViewModel.showRetry ? "Request Failed" : "Processing...")
                    if homeViewModel.showRetry {
                        VStack(spacing: 20){
                            Button("Retry") {
                                Task{
                                    await homeViewModel.retrySummaryRequest()
                                }
                           
                            }
                            .foregroundColor(.white).bold()
                            .padding(.vertical, 8)
                            .frame(width:200
                           /* .padding(.horizontal, 20*/)
                            .background(.gray)
                           
                            .clipShape(.capsule)
                            
                            Button("Restart"){
                                homeViewModel.showProgressView = false
                            }
                            .foregroundColor(.white).bold()
                            .padding(.vertical, 8)
                            .frame(width:200)
//                            .padding(.horizontal, 20)
                            .background(Color.themecolor!)
                            
                            .clipShape(.capsule)
                        }
                    }
                    
                    
                }
                Spacer()
                    
            }
        }
}

//#Preview {
//    ProgressViewUI()
//}
