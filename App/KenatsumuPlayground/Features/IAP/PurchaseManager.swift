//
//  PurchaseManager.swift
//  PaperPipe
//
//  Created by Horik on 18.08.2025.
//

import Combine
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {

    private let productIds = ["cmy_cube"]

    /// Available products for purchase.
    @Published private var productsStorage: [Product] = []
    /// Set of purchased product identifiers.
    @Published private var purchasedProductIDsStorage = Set<String>()

    private let entitlementManager: EntitlementManager
    private var productsLoaded = false
    private var updatesTask: Task<Void, Never>? = nil

    /// Products available for purchase (read-only).
    var products: [Product] {
        productsStorage
    }

    /// Set of purchased product identifiers (read-only).
    var purchasedProductIDs: Set<String> {
        purchasedProductIDsStorage
    }

    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        self.updatesTask = observeTransactionUpdates()
    }

    deinit {
        updatesTask?.cancel()
    }

    /// Loads available products for purchase from the App Store.
    ///
    /// - Throws: Throws an error if product retrieval fails.
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        let fetchedProducts = try await Product.products(for: productIds)
        productsStorage = fetchedProducts
        productsLoaded = true
    }

    /// Initiates the purchase process for a given product.
    ///
    /// - Parameter product: The product to purchase.
    /// - Throws: Throws an error if the purchase process fails.
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase - finish transaction and update entitlements
            await transaction.finish()
            await updatePurchasedProducts()
        case let .success(.unverified(_, _)):
            // Purchase successful but transaction could not be verified
            break
        case .pending:
            // Transaction is pending (e.g., awaiting approval)
            break
        case .userCancelled:
            // User cancelled the purchase
            break
        @unknown default:
            break
        }
    }

    /// Updates the set of purchased product identifiers by checking current entitlements.
    func updatePurchasedProducts() async {
        var updatedPurchasedIDs = Set<String>()
        
        for await verificationResult in Transaction.currentEntitlements {
            guard case .verified(let transaction) = verificationResult else { continue }
            if transaction.revocationDate == nil {
                updatedPurchasedIDs.insert(transaction.productID)
            }
        }

        purchasedProductIDsStorage = updatedPurchasedIDs
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task.detached(priority: .background) { [weak self] in
            guard let self else { return }
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}
