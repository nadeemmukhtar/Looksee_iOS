//
//  StoreScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 11/14/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import OneSignal

struct StoreScreen: View {
    @ObservedObject var state: AppState
    @State var showPack = false
    @State var contentOffset: CGPoint = .zero
    @State var initialAnimation = false
    @State var isShowingDragCard = false
    
    func openInstagram() {
        let instURL: NSURL = NSURL(string: "instagram://user?username=withlooksee")!
        let instWB: NSURL = NSURL(string: "https://instagram.com/withlooksee/")!

        if UIApplication.shared.canOpenURL(instURL as URL) {
            UIApplication.shared.open(instURL as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instWB as URL, options: [:], completionHandler: nil)
        }
    }

    var animateIn: Bool {
        self.initialAnimation && !self.state.isShowingOnboarding
    }

    private func cardOpenAnimations() {
        self.state.isAnimatingTabBar = true
        self.state.isShowingPack = true
        self.state.animateCardOpen = true
    }

    var body: some View {
        ZStack {

            LinearGradient( gradient: Gradient(colors: [
                Color.primaryBackgroundColor,
                Color.splashColor
            ]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .frame(width: screenWidth, height: screenHeight)
            
            // MARK: - Main Content
            ScrollableView(self.$contentOffset, animationDuration: 0.5, action: { _ in }) {
                Spacer().frame(height: isIPhoneX ? 110 : 90)
                VStack(spacing: 2) {

                    /// Featured Pack
                    ForEach(FeaturedPacks) { category in
                        ForEach(category.packs) { pack in
                            Button(action: {
                                self.state.selectedPack = pack
                                self.cardOpenAnimations()

                                //Uncommet this out To test the DragCard and comment out the two lines above
                                //                                self.state.dragCard = true
                                //                                self.state.isAnimatingTabBar = true
                                //                                self.state.animateCardOpen = true
                            }) {
                                StoreFeaturedView(
                                    image: pack.avatar,
                                    name: pack.name)
                                    .padding(.bottom, 20)
                            }
                            .buttonStyle(ButtonBounce())
                        }
                    }
                    .opacity(self.animateIn ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3))
                    .scaleEffect(self.animateIn ? 1 : 0.8)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))

                    /// Nature Packs
                    ForEach(NaturePacks) { category in
                        StoreTextHeader(text: category.name)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(category.packs) { pack in
                                    GeometryReader { geometry in
                                        StoreCellView(
                                            image: pack.avatar,
                                            name: pack.name
                                        )
                                            .rotation3DEffect(Angle(degrees:
                                                Double(geometry.frame(in: .global).minX - 40) / -20
                                            ), axis: (x: 0, y: 10.0, z: 0))
                                    }
                                    .onTapGesture {
                                        self.state.selectedPack = pack
                                        self.cardOpenAnimations()
                                    }
                                    .frame(width: screenWidth - 60, height: 240)
                                    .padding(.vertical, 18)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .offset(x: self.animateIn ? 0 : screenWidth)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))



                    /// Urban Packs
                    ForEach(UrbanPacks) { category in
                        StoreTextHeader(text: category.name)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(category.packs) { pack in
                                    StoreSmallCellView(
                                        image: pack.avatar,
                                        name: pack.name,
                                        action: {
                                            self.state.selectedPack = pack
                                            self.cardOpenAnimations()
                                    })
                                }
                                .frame(width: 110, height: 140)
                                .padding(.top, 18)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 15)
                        }
                    }
                    .frame(width: screenWidth)
                    .offset(x: self.animateIn ? 0 : screenWidth)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))

                    /// Fashion Packs
                    Group {
                        StoreTextHeader(text: "Fashion Packs")
                        VStack(alignment: .leading) {
                            ForEach(FashionPacksRowOne) { category in
                                HStack {
                                    ForEach(category.packs) { pack in
                                        StoreMediumCellView(image: pack.avatar, name: pack.name)
                                            .onTapGesture {
                                                self.state.selectedPack = pack
                                                self.cardOpenAnimations()
                                        }
                                    }
                                }
                            }
                            
                            ForEach(FashionPacksRowTwo) { category in
                                HStack {
                                    ForEach(category.packs) { pack in
                                        StoreMediumCellView(image: pack.avatar, name: pack.name)
                                            .onTapGesture {
                                                self.state.selectedPack = pack
                                                self.cardOpenAnimations()
                                        }
                                    }
                                }
                            }
                            
                            ForEach(FashionPacksRowThree) { category in
                                HStack {
                                    ForEach(category.packs) { pack in
                                        StoreMediumCellView(image: pack.avatar, name: pack.name)
                                            .onTapGesture {
                                                self.state.selectedPack = pack
                                                self.cardOpenAnimations()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    .opacity(self.animateIn ? 1 : 0)
                    .animation(.easeInOut(duration: 0.4))

                    /// Model Packs
                    ForEach(ModelPacks) { category in
                        StoreTextHeader(text: category.name)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(category.packs) { pack in
                                    GeometryReader { geometry in
                                        StoreCellView(
                                            image: pack.avatar,
                                            name: pack.name
                                        )
                                            .rotation3DEffect(Angle(degrees:
                                                Double(geometry.frame(in: .global).minX - 40) / -20
                                            ), axis: (x: 0, y: 10.0, z: 0))
                                    }
                                    .onTapGesture {
                                        self.state.selectedPack = pack
                                        self.cardOpenAnimations()
                                    }
                                    .frame(width: screenWidth - 60, height: 240)
                                    .padding(.vertical, 18)
                                }
                            }.padding([.leading, .bottom, .trailing], 25)
                        }
                    }

                    /// Lifestyle Packs
                    ForEach(LifestylePacks) { category in
                        StoreTextHeader(text: category.name)
                        VStack(spacing: 0) {
                            ForEach(category.packs) { pack in
                                StoreListView(
                                    image: pack.avatar,
                                    name: pack.name
                                )
                                    .padding(.leading, 20)
                                    .onTapGesture {
                                        self.state.selectedPack = pack
                                        self.cardOpenAnimations()
                                }
                                .frame(width: screenWidth - 50, height: 85)
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    /// Instagram Footer
                    StoreFooterView()

                    /// Bottom Spacing
                    Spacer().frame(width: 0, height: 160)
                }
            }

            // MARK: - Nav

            VStack {
                Spacer().frame(height: isIPhoneX ? 30 : 10)
                Image("nav-logo")
                    .shadow(color: Color.black, radius: 20, x: 0, y: 0)
                    .onTapGesture {
                        self.contentOffset = CGPoint(x: 0, y: 0)
                }
                .opacity(self.animateIn ? 1 : 0)
                .animation(.easeInOut(duration: 0.3))
                .scaleEffect(self.animateIn ? 1 : 0.8)
                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                Spacer()
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
            
            if self.state.isShowingPack {
                PackCard(state: state, selectedPack: self.$state.selectedPack, aPurchasedPack: isPackPurchased())
                    .offset(y: state.animateCardOpen ? 0 : screenHeight)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                    .transition(.move(edge: .bottom))
            }
            if self.state.isShowingOnboarding {
                OnboardingScreen(state: state)
                    .offset(y: self.state.isAnimatingOnboarding ? 27 : screenHeight + 100)
                    .animation(Animation.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0).speed(0.8))
            }

            StatusBarMaskView()
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.initialAnimation = true
                if self.state.isShowingOnboarding {
                    self.state.isAnimatingOnboarding  = true
                }
            }
            
            self.verifySubscription()
        }
    }
    
    func isPackPurchased() -> Bool {
        let purchased = PurchasedPacks.contains(where: { $0.packs.contains(where: { $0.name == self.state.selectedPack?.name }) })
        return purchased
    }
    
    func verifySubscription() {
        let subscription = UserDefaults.standard.bool(forKey: "Subscription")
        if subscription {
            Subscription.shared.autoRenewableVerifyPurchase { status in
                if status == "purchased" {
                    self.purchasePack()
                }
                else if status == "expired" {
                    self.removePack()
                }
            }
        }
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
    
    func removePack() {
        let ppacks:[String] = []
        UserDefaults.standard.set(ppacks, forKey: "PurchasedPacks")
        
        PurchasedPacks.removeAll()
        self.state.sPurchasedPacks = PurchasedPacks
    }
}

struct StoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        StoreScreen(state: AppState())
    }
}


struct StoreFooterView: View {

    func openInstagram() {
        let instURL: NSURL = NSURL(string: "instagram://user?username=withlooksee")!
        let instWB: NSURL = NSURL(string: "https://instagram.com/withlooksee/")!

        if UIApplication.shared.canOpenURL(instURL as URL) {
            UIApplication.shared.open(instURL as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instWB as URL, options: [:], completionHandler: nil)
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {

            Color.secondaryTextColor.opacity(0.4)
                .frame(width: screenWidth - 50, height: 1, alignment: .center)
                .padding(.vertical, 20)

            TextImageButton(
                title: "@withlooksee",
                image: "instagram-icon",
                color: Color.white.opacity(0.1),
                action: {
                    self.openInstagram()
            })

            Text("Follow us on Instagram to see featured photos")
                .modifier(TextModifier(size: 17, color: Color.secondaryTextColor))
                .frame(width: 260, alignment: .center)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .lineLimit(2)
        }
    }
}

struct StoreTextHeader: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .modifier(TextModifier(size: 22))
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 10)
    }
}
