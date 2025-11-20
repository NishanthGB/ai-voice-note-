//
//  ContactUs.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 16/10/25.
//

import SwiftUI

struct ContactUs: View {
    @Environment(\.dismiss) var dismiss
//    @State private var email = "support@inventoone.com"
//    @State private var carbonCopy = "user@gmail.com"
//    @State private var subject = "New Age Currency App Report"
//    @State private var description = ""
    @State var contactViewModel = SettingView.ContactUsViewModel()
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading,spacing:50){
                VStack(alignment: .leading,spacing:15){
                    HStack{
                        Button{
                            dismiss()
                        }label: {
                            Image(systemName: "multiply")
                                .foregroundStyle(.gray)
                                .font(.title)
                                .padding(10)
                                .background(.gray.opacity(0.2))
                                .clipShape(.circle)
                        }
                        Spacer()
                        Button{
                            Task {
                               await contactViewModel.ContactUs()
//                                do {
//                                    let body = ContactRequest(
//                                        email: "support@inventoone.com",
//                                        carbonCopy: "user@gmail.com",
//                                        subject: "New Age Currency App Report",
//                                        description: "we want offline storage too",
//                                        userId: "tester"
//                                    )
//
//                                    let response = try await ContactAPIService.shared.sendContact(request: body)
//
//                                    print("Success: \(response.message)")
//                                    print("Contact ID: \(response.contactId)")
//
//                                } catch {
//                                    print("Error sending contact:", error.localizedDescription)
//                                }
                            }

                        }label: {

                            Image(systemName: "arrow.up")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .fill(Color.white)
                                                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                                )
                                
                        }
                    }
                   Text("New Age AN App Report")
                       .font(.title)
                       .fontWeight(.bold)
                }
                .padding(.trailing)
                VStack(alignment: .leading){
                    HStack{
                        Text("To:")
                            .foregroundStyle(.gray)
                        TextField("",text: $contactViewModel.email)
                            .font(.callout)
                            .foregroundStyle(.blue)
                            .fontWeight(.semibold)
                    }
                   
                    Divider()
                    HStack{
                        Text("CC/BCC,From:")
                            .foregroundStyle(.gray)
                        TextField("",text: $contactViewModel.carbonCopy)
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }
                    Divider()
                    HStack{
                        Text("Subject:")
                            .foregroundStyle(.gray)
                        TextField("",text: $contactViewModel.subject)
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                           
                    }
                    Divider()
                     VStack(alignment: .leading){
                         Text("Please Describe your problem:")
                         TextEditor(text: $contactViewModel.description)
                             .frame(height:100)
                         Text("Sent from iPhoe")
                     }
                }
               Spacer()
                
            }
            .padding(.leading)
            .padding(.top)
           
        }
    }
}

#Preview {
    ContactUs()
}
