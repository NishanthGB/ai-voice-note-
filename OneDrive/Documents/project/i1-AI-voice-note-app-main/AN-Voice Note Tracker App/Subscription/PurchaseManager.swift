//
//  PurchaseManager.swift
//  AN-Voice Note Tracker App
//
//  Created by Aditya Choubisa on 15/11/25.
//

import Foundation
import StoreKit
import Combine
import SwiftUI

/// PurchaseManager: handles fetching products, purchasing, restoring and checking entitlements using StoreKit 2.
/// Replace productIDs below with the product IDs you create in App Store Connect.
@MainActor
final class PurchaseManager: ObservableObject {
    // Example product identifiers (replace with your real IDs)
    private let productIDs: [String] = [
        "com.yourcompany.voicenotetracker.premium.monthly",
        "com.yourcompany.voicenotetracker.premium.yearly"
    ]

    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var purchaseInProgress: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isUnlocked: Bool = false

    // Persist entitlement locally (also rely on transaction check)
    @AppStorage("isPremiumUser") private var storedPremium: Bool = false

    init() {
        // Immediately check current entitlement and fetch products
        Task {
            await refreshCustomerProductStatus()
            await fetchProducts()
        }
    }

    /// Fetch products from App Store
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let products = try await Product.products(for: productIDs)
            // Sort or pick prefered product first
            self.products = products.sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
            self.products = []
        }
        isLoading = false
    }

    /// Purchase a product
    func purchase(_ product: Product) async {
        purchaseInProgress = true
        errorMessage = nil
        do {
            //This tells StoreKit to open the official Apple payment sheet.
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                // Verify the transaction
                let transaction = try verification.payloadValue
                // For safe apps: run server side validation. Here we check locally.
                await updateCustomerProductStatus()
                // Finish the transaction if needed
                await finishTransactionIfNeeded(result: verification)
            case .userCancelled:
                errorMessage = "Purchase cancelled."
            case .pending:
                errorMessage = "Purchase pending — please wait."
            @unknown default:
                errorMessage = "Unknown purchase result."
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        purchaseInProgress = false
    }

    /// Restore purchases (StoreKit2 does not have explicit restore; you check current entitlements)
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        do {
            // In StoreKit 2, you can call AppStore.sync() to fetch latest transactions then check entitlements
            try await AppStore.sync()
            await updateCustomerProductStatus()
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
        }
        isLoading = false
    }

    /// Update local entitlement based on current transactions
    func updateCustomerProductStatus() async {
        await refreshCustomerProductStatus()
    }

    /// Check current entitlements and set isUnlocked accordingly
    private func refreshCustomerProductStatus() async {
        // Default false
        var hasAccess = false

        // Iterate current entitlements (active subscriptions / non-consumables)
        for await verificationResult in Transaction.currentEntitlements {
            do {
                let transaction = try verificationResult.payloadValue
                // Decide which productIDs grant premium access
                if productIDs.contains(transaction.productID) {
                    hasAccess = true
                    break
                }
            } catch {
                // handle verification failure if needed
                print("Transaction verification failed: \(error.localizedDescription)")
            }
        }

        isUnlocked = hasAccess || storedPremium // storedPremium gives quicker local access
        storedPremium = isUnlocked
    }

    /// Helper: finish transaction if needed
    private func finishTransactionIfNeeded(result: VerificationResult<StoreKit.Transaction>) async {
        if case .verified(let transaction) = result {
            await transaction.finish()
        }
    }

}
