//
//  SettingsScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 11/13/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var state: AppState
    @State private var pulsate = false
    @State private var soundEffectsOn = true
    @State private var showingAlert = false

    var accessOpen = screenHeight / 2 -  420 / 2 + (isIPhoneX ? 10 : 25)
    
    private func cardOpenAnimations() {
        self.state.isAnimatingTabBar = true
        self.state.isShowingSubscription = true
        self.state.animateCardOpen = true
    }
    
    func openInstagram() {
        let instURL: NSURL = NSURL(string: "instagram://user?username=withlooksee")!
        let instWB: NSURL = NSURL(string: "https://instagram.com/withlooksee/")!
        
        if UIApplication.shared.canOpenURL(instURL as URL) {
            UIApplication.shared.open(instURL as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instWB as URL, options: [:], completionHandler: nil)
        }
    }
    
    func openLookseeWebsite() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        let url = URL(string: "http://www.extravisual.co")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    func openPrivacy() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        let url = URL(string: "http://www.extravisual.co/privacy/")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    func openTerms() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        let url = URL(string: "http://www.extravisual.co/terms/")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }

    func rateUs() {
        let url = URL(string: "https://apps.apple.com/us/app/looksee/id888457090?action=write-review")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func openNotificationAccess() {
        self.state.isAnimatingTabBar = true
        self.state.notificationAccess = true
        self.state.showBlurCard = true
    }
    
    var body: some View {
        ZStack {
            ScrollView (showsIndicators: false) {
                Spacer().frame(height: isIPhoneX ? 95 : 55)
                HStack {
                    Text("Settings")
                        .font(Font.custom(Font.textaAltHeavy, size: 34))
                        .foregroundColor(Color.primaryTextColor)
                        .padding(.bottom, 5)
                    Spacer()
                }
                .padding(.leading, 20)
                
                VStack (spacing: 10) {
                    Group {
                        TextImageButton(title: "Unlock all packs", image: "star-icon", color: Color.yellowColor.opacity(0.1), textColor: Color.yellowColor, action: { self.cardOpenAnimations() })
                        TextImageButton(title: "Restore purchases", action: {
                            Subscription.shared.restorePurchases { isPurchased in
                                if isPurchased {
                                    self.saveSubscription()
                                    self.purchasePack()
                                }
                            }
                        })
                    }
                    
                    Group {
                        TextHeader(text: "Be Social")
                        TextImageButton(title: "Direct message", action: { self.openInstagram() })
                        TextImageButton(title: "Follow us on Instagram", action: { self.openInstagram() })
                    }
                    
                    Group {
                        TextHeader(text: "More")
                        TextImageButton(title: "About us", action: { self.openLookseeWebsite() })
                        TextImageButton(title: "Rate us on The App Store", action: { self.rateUs() })
                        TextImageButton(title: "Privacy policy", action: { self.openPrivacy() })
                        TextImageButton(title: "Terms of use", action: { self.openTerms() })
                    }
                    
                    VStack {
                        Image("settings-logo")
                            .renderingMode(.template)
                            .foregroundColor(Color.secondaryTextColor.opacity(0.3))
                        Text("v2.0")
                            .modifier(TextModifier(size: 18, font: Font.textaAltBlack, color: Color.secondaryTextColor))
                        
                    }
                    .padding(.top, 40)
                    
                    
                    Spacer().frame(height: 140)
                }
            }

            if UserDefaults.timesNotificationShown == 0 {
                VStack {
                    Spacer().frame(height: 45)
                    HStack {
                        Spacer()
                        ImageButton(image: "notification-icon", width: 50, height: 50, corner: 25, background: Color.clear, blur: true, action: {
                            self.openNotificationAccess()
                        })
                            .scaleEffect(self.pulsate ? 1 : 0.9)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).speed(1.5))
                            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 0)
                            .onAppear() {
                                self.pulsate.toggle()
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }

            // MARK: - Diming background when card presents
            
            LinearGradient( gradient: Gradient(colors: [
                Color.black.opacity(0.5),
                Color.black.opacity(1)
            ]), startPoint: .top, endPoint: .center)
                .edgesIgnoringSafeArea(.all)
                .frame(width: screenWidth, height: screenHeight)
                .opacity(state.animateCardOpen ? 1 : state.showBlurCard ? 0.4 : 0)
                .animation(.easeInOut(duration: 0.5))
                .onTapGesture {}
            
            // MARK: - Pack card
            
            if self.state.isShowingSubscription {
                SubscriptionCard(state: state)
                    .offset(y: state.animateCardOpen ? 0 : screenHeight)
                    .transition(.move(edge: .bottom))
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
            }

            if self.state.notificationAccess {
                NotificationPermissionCard(state: state)
                    .offset(y: state.showBlurCard ? accessOpen : screenHeight)
                    .animation(Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0).speed(0.8))
                    .transition(.move(edge: .bottom))
            }

            StatusBarMaskView()
        }
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
        for pack in LifestylePacks[0].packs { addPackToPurchase(selectedPack: pack) }
        
        self.state.sPurchasedPacks = PurchasedPacks
    }
    
    func addPackToPurchase(selectedPack: FilterPack) {
        if !PurchasedPacks.contains(where: { $0.packs.contains(where: { $0.name == selectedPack.name }) }) {
            !PurchasedPacks.isEmpty ? !PurchasedPacks[0].packs.isEmpty ?
                PurchasedPacks[0].packs.insert(selectedPack, at: 0) : PurchasedPacks[0].packs.append(selectedPack) : PurchasedPacks.append(PackData(name: "Purchased", packs: [selectedPack]))
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(state: AppState())
    }
}

struct TextHeader: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    var body: some View {
        HStack {
            Text(text)
                .modifier(TextModifier(color: Color.secondaryTextColor.opacity(0.6)))
                .padding(.leading, 25)
            Spacer()
        }
        .frame(width: screenWidth - 30)
        .padding(.top, 30)
        .padding(.bottom, 5)
    }
}
