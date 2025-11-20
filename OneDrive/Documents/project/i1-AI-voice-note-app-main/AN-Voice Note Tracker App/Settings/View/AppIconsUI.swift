//
//  AppIconsUI.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 11/11/25.
//

import SwiftUI

struct AppIconsUI: View {
    let layout = [
        GridItem(.adaptive(minimum: 80)),
    ]
     var allAppIcons = ["Image5","Image1","Image2","Image3","Image4"]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(allAppIcons, id: \.self) { appIcon in
                    Image("\(appIcon)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                      
                }
            }
        }
        .navigationTitle("App Icons")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button{
                
            } label: {
                Text("Save")
            }
        }
    }
}

#Preview {
    AppIconsUI()
}
