//
//  NotesDetailView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Kumar Choubisa on 14/10/25.
//



import SwiftUI

struct NotesDetailView: View {
//    @Binding var selectedTabBar: Int
    var noteItem: NoteItem
    @Binding var path: NavigationPath
    @State private var selectedTab = "AI Notes"
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteNoteAlert: Bool = false
    var allTabs = ["AI Notes","Transcript","Action Items"]
    var actionItems = [
        "Add examples of accessibility in public transport",
        "Expand on the role of technology in accessibility",
        "Expand on the role of technology in accessibility",
        "Proofread essay for grammar and flow"
    ]
    func formatISODate(_ isoString: String, to format: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current

        return formatter.string(from: date)
    }
 
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                ForEach(allTabs, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(noteItem.title ?? "")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.title)
                            .fontWeight(.bold)

                        if let date = noteItem.createdAt {
                            let newStringDate = formatISODate(date, to: "dd MMM yyyy")
                            Text(newStringDate ?? "")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                        }

                        Divider()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                    // MARK: AI Notes Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("AI Notes (Summary)")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(noteItem.summary ?? "")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                            .frame(width: 300)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .id("AI Notes") // 👈 add ID

                    // MARK: Transcript Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Transcript (Full Text)")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(noteItem.transcript ?? "")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .frame(width: 350)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .id("Transcript") // 👈 add ID

                    // MARK: Action Items Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Action Items")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .font(.title2)
                            .fontWeight(.semibold)

                        VStack(alignment: .leading) {
                            ForEach(actionItems, id: \.self) { item in
                                Text(item)
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.callout)
                            }
                        }
                        .frame(width: 300)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .id("Action Items") // 👈 add ID
                }
                // 👇 Smooth scrolling when picker changes
                .onChange(of: selectedTab) { value in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(value, anchor: .top)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Note?",isPresented: $showDeleteNoteAlert){
            Button("Cancel"){
                showDeleteNoteAlert = false
            }
            Button("Delete"){
                Task{
                    do {
                        let success = try await APIClient.shared.deleteNote(noteId: noteItem.id)
                        if success {
                            print("Deleted!")
                            withAnimation{
                                path = NavigationPath()
                            }
                        } else {
                            print("No-op or failed")
                        }
                    } catch {
                        print("Error deleting note:", error)
                    }

                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                GlassEffectContainer(spacing: 40.0) {
                    HStack(spacing: 40.0) {
                        Button {} label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                )
                        }
                        Button(role: .destructive) {
                            showDeleteNoteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }
}
