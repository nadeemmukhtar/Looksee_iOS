//
//  Subscription.swift
//  looksee
//
//  Created by Appcrates_Dev on 3/13/20.
//  Copyright © 2020 Extra Visual, Inc. All rights reserved.
//

import UIKit
import SwiftyStoreKit

enum RegisteredPurchase: String {

    case nonConsumablePurchase
    case consumablePurchase
    case nonRenewingPurchase
    case autoRenewableWeekly
    case autoRenewableMonthly
    case autoRenewableYearly
}

enum SubscriptionPack: String {

    case BS
    case BM
    case ST
    case BH
    case CB
    case CC
    case CY
    case CT
    case CH
    case DR
    case DB
    case DF
    case ER
    case EC
    case FS
    case FB
    case GP
    case HB
    case HF
    case HD
    case IN
    case JP
    case JDL
    case JY
    case JV
    case JAM
    case JM
    case KR
    case KA
    case KK
    case MC
    case NB
    case OV
    case PD
    case PU
    case RJ
    case RP
    case SA
    case CI
    case SBN
    case SM
    case SB
    case TH
    case TL
    case TD
    case Monthly
    case Yearly
}

class Subscription: NSObject {
    
    static var shared = Subscription()

    private let appBundleId = "com.quebecdrive.Looksee"
    
    // MARK: non consumable
    func nonConsumablePurchase(pack: SubscriptionPack, completion: @escaping (Bool) -> Void) {
        purchase(.nonConsumablePurchase, pack: pack, completion: completion)
    }
    
    func nonConsumableVerifyPurchase() {
        verifyPurchase(.nonConsumablePurchase)
    }
    
    // MARK: auto renewable
    func autoRenewablePurchase(pack: SubscriptionPack, completion: @escaping (Bool) -> Void) {
        purchase(.autoRenewableMonthly, pack: pack, completion: completion)
    }
    
    func autoRenewableVerifyPurchase(completion: @escaping (String) -> Void) {
        verifySubscriptions([.autoRenewableMonthly, .autoRenewableYearly], completion: completion)
    }
}

extension Subscription {

    func purchase(_ purchase: RegisteredPurchase, pack: SubscriptionPack, completion: @escaping (Bool) -> Void) {

        var productId = appBundleId + "." + pack.rawValue
        if pack == .Monthly {
            productId = appBundleId + "." + "5M"
        } else if pack == .Yearly {
            productId = appBundleId + "." + "1Y"
        }
        //NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            //NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(_) = result {
                completion(true)
            } else {
                completion(false)
            }

            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }

    func restorePurchases(completion: @escaping (Bool) -> Void) {

        //NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            //NetworkActivityIndicatorManager.networkOperationFinished()
            
            if results.restoreFailedPurchases.count > 0 {
                completion(false)
            } else if results.restoredPurchases.count > 0 {
                completion(true)
            } else {
                completion(false)
            }

            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }

    func verifyReceipt() {

        //NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            //NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "97e6152af2d24c939a6645c6c874f4f0")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {

        //NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            //NetworkActivityIndicatorManager.networkOperationFinished()

            switch result {
            case .success(let receipt):

                let productId = self.appBundleId + "." + purchase.rawValue

                switch purchase {
                case .autoRenewableWeekly, .autoRenewableMonthly, .autoRenewableYearly:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                case .nonRenewingPurchase:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .nonRenewing(validDuration: 60),
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifyPurchase(purchaseResult, productId: productId))
                }

            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    func verifySubscriptions(_ purchases: Set<RegisteredPurchase>, completion: @escaping (String) -> Void) {
        
        //NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            //NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let packs = [self.appBundleId + "." + "5M", self.appBundleId + "." + "1Y"]
                let productIds = Set(packs.map { $0 })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                //self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: productIds))
                
                
                switch purchaseResult {
                case .purchased(_, _):
                    completion("purchased")
                case .expired(_, _):
                    completion("expired")
                case .notPurchased:
                    completion("notPurchased")
                }
                
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
                
                completion("error")
            }
        }
    }
}

extension Subscription {

    func alertWithTitle(_ title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }

    func showAlert(_ alert: UIAlertController) {
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        guard vc?.presentedViewController != nil else {
            vc?.present(alert, animated: true, completion: nil)
            return
        }
    }

    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {

        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }

    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }

    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {

        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }

    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {

        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }

    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {

        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }

    func alertForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) -> UIAlertController {

        switch result {
        case .purchased:
            print("\(productId) is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("\(productId) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
}
