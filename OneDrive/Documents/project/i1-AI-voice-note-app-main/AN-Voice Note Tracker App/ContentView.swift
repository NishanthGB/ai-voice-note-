//
//  ContentView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

//import SwiftUI
//import LocalAuthentication
//
//struct ContentView: View {
//    @State private var isUnlocked = false
//    var body: some View {
//        VStack {
//            if isUnlocked{
//              SplashScreenView()
//            }else{
//                Image(systemName: "faceid")
//                    .font(.largeTitle)
//                    .padding()
//               
//            }
//        }
//        .onAppear(perform: authenticate)
//    }
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "We need to unlock your data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                   isUnlocked = true
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
