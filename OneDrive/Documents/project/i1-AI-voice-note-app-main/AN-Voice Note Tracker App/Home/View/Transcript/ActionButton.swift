//
//  ButtonAction.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 16/11/25.
//

import Foundation
import SwiftUI


struct DiscardButton: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text("Discard")
            .fontWeight(.semibold)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .frame(width:150)
            .padding(.vertical,10)
            .glassEffect(in: .capsule)
    }
}

struct SaveButton:View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text("Save")
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(width:150)
            .padding(.vertical,10)
            .glassEffect(.regular.tint(.themecolor).interactive(), in: .capsule)

    }
}
