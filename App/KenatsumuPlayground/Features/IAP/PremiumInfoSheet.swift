import SwiftUI
import StoreKit

struct PremiumInfoSheet: View {
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @Binding var isPresented: Bool
    @State private var cmyCubeProduct: Product?
    
    private let cmyCubeProductID = "cmy_cube"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                VStack(spacing: 6) {
                    Text("Go Pro")
                        .font(.largeTitle.bold())
                    Text("Unlock CMY Cube and future updates")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    Group {
                        if let product = cmyCubeProduct {
                            HStack(spacing: 12) {
                                Image(systemName: "cube.transparent")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                                    .frame(width: 32, height: 32)
                                    .padding(8)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CMY Cube")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text("One-time purchase")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer(minLength: 8)
                                
                                Text(product.displayPrice)
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(.regularMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        } else {
                            HStack(spacing: 12) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                Text("Loading price…")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(.regularMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                            )
                        }
                    }
                    
                    Button {
                        guard let product = cmyCubeProduct else { return }
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "lock.open.fill")
                            Text("Continue")
                                .fontWeight(.semibold)
                        }
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Group {
                                if cmyCubeProduct != nil {
                                    SunriseGradient()
                                } else {
                                    Color.gray
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(cmyCubeProduct == nil)
                    
                    Text("Payment will be charged to your Apple ID. Availability and pricing may vary by region.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                    
                    Button {
                        _ = Task<Void, Never> {
                            do { try await AppStore.sync() } catch { print(error) }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise.circle")
                            Text("Restore Purchases")
                                .fontWeight(.semibold)
                        }
                        .font(.callout)
                    }
                    .buttonStyle(.borderless)
                    .tint(.primary)
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal)
        }
        .task {
            _ = Task<Void, Never> {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
        .onAppear {
            cmyCubeProduct = purchaseManager.products.first { $0.id == cmyCubeProductID }
        }
        .onChange(of: purchaseManager.products) { _, newProducts in
            cmyCubeProduct = newProducts.first { $0.id == cmyCubeProductID }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }

    }
}

#if DEBUG
#Preview {
    let entitlementManager = EntitlementManager()
    let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
    
    PremiumInfoSheet(isPresented: .constant(true))
        .environmentObject(entitlementManager)
        .environmentObject(purchaseManager)
}
#endif
