//
//  AllNotesUI.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//

import SwiftUI
import SwiftData


struct AllNotesUI: View {
//    @Binding var  selectedTabBar: Int
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    let layout = [
        GridItem(.adaptive(minimum: 150)),
    ]
     @State var allNotesItem: [NoteItem] = []
    @Query var allNotes: [Notes]
    func formatISODate(_ isoString: String, to format: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current   // or UTC

        return formatter.string(from: date)
    }

@State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path){
            VStack(spacing:0){
                HeaderComponent(title: "Notes")
                    .padding(.bottom,8)
                ScrollView(showsIndicators: false){
                    LazyVGrid(columns: layout, spacing: 5) {
                        ForEach(allNotesItem) { note in
                            NavigationLink(value: note){
                                VStack(alignment: .leading,spacing:5){
                                    Text(note.title ?? "")
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(note.transcript ?? "")
                                        .font(.callout)
                                        .foregroundStyle(colorScheme == .dark ? .white : .gray)
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    
                                    if let date = note.createdAt{
                                        let newStringDate = formatISODate(date, to: "dd MMM yyyy")
                                        Text(newStringDate ?? "")
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                    }
                                   
                                }
                                .padding()
                                .background(colorScheme == .dark ? .gray.opacity(0.2) : .white)
                                .cornerRadius(10)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    }

                    .padding(.horizontal)
                }
                
            }
            .navigationDestination(for: NoteItem.self){ selection in
                NotesDetailView(noteItem: selection,path: $path)
            }
            .padding(.vertical)
            .background(Color(UIColor.systemGroupedBackground))
//            .navigationBarHidden(true)
            .task{
                print("AllNotesUI called")
                do{
                 allNotesItem = try await AIServiceHelper.shared.getNotes(userId: "tester")
                    print(" 78 allNotesItem: \(allNotesItem)")
                }catch{
                    
                }
            }
            
        }
    }
}

//#Preview {
//    AllNotesUI()
//}

