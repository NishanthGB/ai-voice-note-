//
//  PaywallView.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 15/11/25.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var purchaseManager = PurchaseManager()
    @Binding var isPresented: Bool // bind to whether paywall is shown

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Go Premium")
                        .font(.largeTitle)
                        .bold()
                    Text("Unlock unlimited voice notes, cloud backup and advanced analytics.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)

                // Feature list
                VStack(alignment: .leading, spacing: 10) {
                    FeatureRow(title: "Unlimited voice notes", subtitle: "Record and store without limits.")
                    FeatureRow(title: "Cloud backup & sync", subtitle: "Access notes across devices.")
                    FeatureRow(title: "Export & share", subtitle: "Save transcripts & share easily.")
                    FeatureRow(title: "Priority support", subtitle: "Faster help from our team.")
                }
                .padding()

                Spacer()

                // Products / CTA
                if purchaseManager.isLoading {
                    ProgressView("Loading offers...")
                        .padding()
                } else if let error = purchaseManager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // Show each product button
                    ForEach(purchaseManager.products, id: \.id) { product in
                        ProductButton(product: product) {
                            Task {
                                await purchaseManager.purchase(product)
                                // After purchase attempt, check if unlocked
                                if purchaseManager.isUnlocked {
                                    // Dismiss and grant access
                                    isPresented = false
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Small note
                    Text("Price shown is set by App Store. Subscriptions renew automatically.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }

                // Restore + Close
                HStack(spacing: 20) {
                    Button(action: {
                        Task {
                            await purchaseManager.restorePurchases()
                            if purchaseManager.isUnlocked {
                                isPresented = false
                            }
                        }
                    }) {
                        Text("Restore Purchases")
                            .foregroundStyle(Color.themecolor!)
                    }
                    .buttonStyle(.bordered)

                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Not now")
                            .bold()
                    }
                   .buttonStyle(.borderedProminent)
                   .tint(.themecolor)
//                    .padding()
//                    .background(Color.themecolor)
//                    .clipShape(.capsule)
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            Task {
                await purchaseManager.fetchProducts()
                await purchaseManager.updateCustomerProductStatus()
            }
        }
    }
}

// MARK: - Subviews

struct FeatureRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading) {
                Text(title).bold()
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct ProductButton: View {
    let product: Product
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(product.displayName).bold()

                        Text(product.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                // Show localized price
                Text(product.displayPrice)
                    .bold()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).strokeBorder())
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    PaywallView(isPresented: .constant(true))
}
