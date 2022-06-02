//
//  SubscriptionCard.swift
//  looksee
//
//  Created by Justin Spraggins on 2/15/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct SubscriptionCard: View {
    @ObservedObject var state: AppState
    @State private var contentOffset: CGPoint = CGPoint(x: 0, y: 0)
    @State private var yearlySub = false
    @State private var monthlySub = false
    @State private var freeTrial = false

    private func cardCloseAnimations() {
        self.state.isAnimatingTabBar = false
        self.state.animateCardOpen = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.state.isShowingPack = false
        }
    }
    
    var body: some View {
        ScrollableView(self.$contentOffset, animationDuration: 0.5, action: { value in
            self.cardCloseAnimations()
        }) {
            Spacer().frame(height: isIPhoneX ? 110 : 50)
            ZStack {
                // MARK: - Background for when card presents
                LinearGradient( gradient: Gradient(colors: [
                    Color.primaryBackgroundColor,
                    Color.black
                ]), startPoint: .top, endPoint: .bottom)
                    .frame(width: screenWidth)
                
                VStack {
                    ZStack (alignment: .bottom) {
                        GeometryReader { geometry in
                            Image("NeaveBozorgi")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [
                                                Color.black.opacity(0.1),
                                                Color.black.opacity(1)
                                            ]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                            )
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: geometry.frame(in: .global).minY/9)
                                .clipped()
                        }
                        .frame(width: screenWidth, height: 250)
                        
                        VStack {
                            HStack {
                                Spacer()
                                ImageButton(
                                    image: "nav-close",
                                    background: Color.white.opacity(0.1),
                                    blur: true,
                                    action: { self.cardCloseAnimations() })
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                            Image("looksee-logo")
                                .padding(.top, 30)
                                .padding(.bottom, 15)
                            Text("To install all filter packs choose a premium subscription.")
                                .modifier(TextModifier())
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)

                        }
                    }
                    Spacer().frame(height: 40)
                    TextImageButton(
                        title: self.monthlySub ? "Subscribed (monthly)" : "$5.99 per month",
                        color: self.monthlySub ? Color.white.opacity(0.05) : Color.white.opacity(0.1),
                        textColor: self.monthlySub ? Color.whiteTextColor.opacity(0.6) : Color.whiteTextColor,
                        action: {
                            Subscription.shared.autoRenewablePurchase(pack: .Monthly) { isPurchased in
                                if isPurchased {
                                    self.saveSubscription()
                                    self.purchasePack()
                                    self.monthlySub = true
                                }
                            }
                    })
                    TextImageButton(
                        title: self.yearlySub ? "Subscribed (yearly)" : "$39.99 per year",
                        color: self.yearlySub ? Color.white.opacity(0.05) : Color.white.opacity(0.1),
                        textColor: self.yearlySub ? Color.whiteTextColor.opacity(0.6) : Color.whiteTextColor,
                        action: {
                            Subscription.shared.autoRenewablePurchase(pack: .Yearly) { isPurchased in
                                if isPurchased {
                                    self.saveSubscription()
                                    self.purchasePack()
                                    self.yearlySub = true
                                }
                            }
                    })
                    TextImageButton(
                        title: self.freeTrial ? "Subscribed (free trial)" : "Start free trial",
                        image: self.freeTrial ? "check-freeTrial" : "plus-freeTrial",
                        color: Color.blueColor.opacity(0.1),
                        textColor: Color.blueColor,
                        action: {
                            Subscription.shared.autoRenewablePurchase(pack: .Yearly) { isPurchased in
                                if isPurchased {
                                    self.saveSubscription()
                                    self.purchasePack()
                                    self.freeTrial = true
                                }
                            }
                    })
                        .padding(.bottom, 15)
                    
                    VStack (spacing: 5) {
                        Text("After three day free trial an auto-renewable subscription will be activated for $39.99/year")
                            .modifier(TextModifier(size: 15, color: Color.secondaryTextColor.opacity(0.4)))
                            .multilineTextAlignment(.center)
                            .lineSpacing(0)
                            .padding(.horizontal, 20)
                            .frame(height: 60)
                        TextButton(title: "Restore Purchases",
                                   color: Color.clear,
                                   textColor: Color.secondaryTextColor,
                                   width: screenWidth,
                                   background: Color.clear,
                            action: {
                                Subscription.shared.restorePurchases { isPurchased in
                                    if isPurchased {
                                        self.purchasePack()
                                    }
                                }
                        })
                        
                        Text("Payment will be charged to your Apple ID Acount at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptoins may be managed by the user and auto-renewal may be turned off by going to the user’s Account Settgins after purchase.")
                            .modifier(TextModifier(size: 15, color: Color.secondaryTextColor.opacity(0.4)))
                            .multilineTextAlignment(.center)
                            .lineSpacing(0)
                            .padding(.horizontal, 20)
                            .frame(height: 210)
                    }
                    .padding(.top, 20)
                    
                    TextButton(
                        title: "Close",
                        textColor: Color.white.opacity(0.8),
                        width: 100,
                        height: 40,
                        action: {
                            self.contentOffset = CGPoint(x: 0, y: 0)
                            self.cardCloseAnimations()
                    })
                        .padding(.top, 30)
                    Spacer().frame(height: isIPhoneX ? 100 : 70)
                }
            }
            .animation(nil)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func saveSubscription() {
        UserDefaults.standard.set(true, forKey: "Subscription")
    }
    
    func purchasePack() {
        for pack in FeaturedPacks[0].packs { addPackToPurchase(selectedPack: pack) }
        for pack in NaturePacks[0].packs { addPackToPurchase(selectedPack: pack) }
        for pack in FashionPacks[0].packs { addPackToPurchase(selectedPack: pack) }
        for pack in UrbanPacks[0].packs { addPackToPurchase(selectedPack: pack) }
        for pack in ModelPacks[0].packs { addPackToPurchase(selectedPack: pack) }
        
        self.state.sPurchasedPacks = PurchasedPacks
    }
    
    func addPackToPurchase(selectedPack: FilterPack) {
        if !PurchasedPacks.contains(where: { $0.packs.contains(where: { $0.name == selectedPack.name }) }) {
            !PurchasedPacks.isEmpty ? !PurchasedPacks[0].packs.isEmpty ?
                PurchasedPacks[0].packs.insert(selectedPack, at: 0) : PurchasedPacks[0].packs.append(selectedPack) : PurchasedPacks.append(PackData(name: "Purchased", packs: [selectedPack]))
        }
    }
}

struct SubscriptionCard_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionCard(state: AppState())
            .background(Color.splashColor)
            .edgesIgnoringSafeArea(.all)
    }
}
