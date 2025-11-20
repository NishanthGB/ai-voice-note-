//
//  HeaderView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import SwiftUI

struct HeaderView: View {
    @Bindable var homeViewModel : HomeView.HomeViewModel
    var body: some View {
        VStack(alignment: .leading,spacing:20){
            HeaderComponent(title: "Ai Voice Note")
            if !homeViewModel.showTranscript{
                BannerView()
            }
            
        }
    }
}

//#Preview {
//    HeaderView()
//}
