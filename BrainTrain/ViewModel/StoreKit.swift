//
//  StoreKit.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 24.07.2021.
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> ())
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> ())

class StoreKit: NSObject, ObservableObject {
    
    @Published var allRecipes: [Recipe] = []
    @Published var purchaseTapped = false
    
    private let identifiers = Set([
       "com.oknablitz.BrainKeeper.coffee"
    ])
    
    private var completedPurchares:[String] = [] {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for index in self.allRecipes.indices {
                    self.allRecipes[index].isLocked =
                        !self.completedPurchares.contains(self.allRecipes[index].id)
                }
            }
        }
    }
    private var productRequest: SKProductsRequest?
    private var fetchedProducts: [SKProduct] = []
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    private var userDefaultKey = "completedPurchares2"
    
    override init () {
        super.init()
        
        startObservingpaymentQueue()
        
        fetchProducts() { products in
            self.allRecipes = products.map{ Recipe(product: $0) }
        }
    }
    
     func loadStoredPurchases() {
        if let storedPurchases = UserDefaults.standard.object(forKey: userDefaultKey) as? [String] {
            self.completedPurchares = storedPurchases
        }
    }
    
    
    private func startObservingpaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts (_ completion: @escaping FetchCompletionHandler) {
        guard productRequest == nil else { return }
        
        fetchCompletionHandler = completion
        
        productRequest = SKProductsRequest(productIdentifiers: identifiers)
        
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    private func buy (_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
}

extension StoreKit {
    
    func product (for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {$0.productIdentifier == identifier})
    }
    
    func purchaseProduct(_ product: SKProduct) {
        startObservingpaymentQueue()
        buy(product) { _ in}
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreKit: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            var shouldFinishTransaction = false
            
            switch transaction.transactionState {
            case .purchased, .restored:
                completedPurchares.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
                purchaseTapped = false
            case .failed:
                print("failed")
                purchaseTapped = false
                shouldFinishTransaction = true
            case .deferred, .purchasing:
                print("purchasing")
                purchaseTapped = false
                break
            @unknown default:
                break
            }
            
            if  shouldFinishTransaction  {
                SKPaymentQueue.default().finishTransaction(transaction)
                
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
        
        if !completedPurchares.isEmpty {
            UserDefaults.standard.setValue(completedPurchares, forKey: userDefaultKey)
        }
    }
}

extension StoreKit: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedPoduts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedPoduts.isEmpty  else  {
            print("Couldnt load the products")
            
            if !invalidProducts.isEmpty {
                print("Invalid products fined \(invalidProducts)")
            }
            productRequest = nil
            return
        }
        
     //Cache the fetched products
        fetchedProducts = loadedPoduts
        
    //Notify anyone waiting  on the product load
        
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedPoduts)
            
            self.fetchCompletionHandler = nil
            self.productRequest = nil
        }
        
    }
}
