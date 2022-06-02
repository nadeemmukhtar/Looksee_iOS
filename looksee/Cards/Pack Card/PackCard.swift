//
//  PackCard.swift
//  looksee
//
//  Created by Justin Spraggins on 11/15/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PackCard: View {
    @ObservedObject var state: AppState
    @Binding var selectedPack: FilterPack?
    var aPurchasedPack = false

    @Environment(\.presentationMode) var presentation
    @State var player: AVAudioPlayer?
    @State var pulsate = false
    @State var purchasedPack = false
    @State private var contentOffset: CGPoint = CGPoint(x: 0, y: 0)


    func openInstagram() {
        let instURL: NSURL = NSURL(string: "instagram://user?username=\(self.selectedPack?.instagram ?? "")")!
        let instWB: NSURL = NSURL(string: "https://instagram.com/\(self.selectedPack?.instagram ?? "")/")!

        if UIApplication.shared.canOpenURL(instURL as URL) {
            UIApplication.shared.open(instURL as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instWB as URL, options: [:], completionHandler: nil)
        }
    }

    func playBuySound() {
        let path = Bundle.main.path(forResource: "Bottle", ofType: "aiff")!
        let url = URL(fileURLWithPath: path)
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.volume = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.player?.play()
            }
        } catch {
            // couldn't load file :(
        }
    }
    
    func purchasePack() {
        Subscription.shared.nonConsumablePurchase(pack: purchaseFilter[self.selectedPack!.name]!) { isPurchased in
            if isPurchased {
                self.state.showNotification = true
                self.addPackToPurchase()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.playBuySound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.state.showNotification = false
                    }
                }
            }
        }
    }
    
    func addPackToPurchase() {
        if !PurchasedPacks.contains(where: { $0.packs.contains(where: { $0.name == self.selectedPack?.name }) }) {
            !PurchasedPacks.isEmpty ? !PurchasedPacks[0].packs.isEmpty ?
                PurchasedPacks[0].packs.insert(self.selectedPack!, at: 0) : PurchasedPacks[0].packs.append(self.selectedPack!) : PurchasedPacks.append(PackData(name: "Purchased", packs: [self.selectedPack!]))
            
            self.purchasedPack = true
        }
        
        self.state.sPurchasedPacks = PurchasedPacks
    }

    private func cardCloseAnimations() {
        self.state.isAnimatingTabBar = false
        self.state.animateCardOpen = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.state.isShowingPack = false
        }
    }

    var body: some View {
        ScrollableView(self.$contentOffset, animationDuration: 0.5, action: { value in
            print(value)
            self.cardCloseAnimations()
        }) {
            Spacer().frame(height: isIPhoneX ? 110 : 50)
            ZStack {
                Color.black
                    .frame(width: screenWidth)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                VStack {
                    ZStack(alignment: .bottom) {
                        if self.selectedPack?.avatar != nil {
                            GeometryReader { geometry in
                                Image(self.selectedPack!.avatar)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(
                                                colors: [
                                                    Color.black.opacity(0),
                                                    Color.black.opacity(0.4)
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
                            .frame(height: 195)
                        }

                        VStack {
                            Spacer().frame(height: 35)
                            HStack {
                                Spacer()
                                ImageButton(image: "nav-close", background: Color.white.opacity(0.1), blur: true, action: {
                                    self.cardCloseAnimations()

                                })
                            }
                            .padding(.horizontal, 15)
                            Spacer().frame(height: 30)

                            Text(self.selectedPack?.name ?? "")
                                .font(Font.custom(Font.textaAltHeavy, size: 26))
                                .foregroundColor(Color.white)
                                .animation(nil)
                            Text("Filter Pack")
                                .font(Font.custom(Font.textaAltBold, size: 18))
                                .foregroundColor(Color.white)

                            Spacer().frame(height: 35)

                            TextButton(title: self.aPurchasedPack ? "Installed" : self.selectedPack?.price ?? "",
                                       color: self.aPurchasedPack ? Color.splashColor : Color.blueColor,
                                       textColor: self.aPurchasedPack ? Color.white.opacity(0.7) : Color.white,
                                       textSize: self.aPurchasedPack ? 20 : 22,
                                       width: self.aPurchasedPack ? 132 : 112,
                                       height: 46,
                                       background: self.aPurchasedPack ? Color.clear : Color.blueColor,
                                       blur: self.aPurchasedPack ? true : false,
                                       action: {
                                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                        if !self.aPurchasedPack {
                                            self.purchasePack()
                                        }

                            })
                        }
                        .frame(height: 195)
                    }
                    .padding(.bottom, 30)

                    ///Can you set this up to show teh three filters (photo, name) for the pack
                    VStack (spacing: 3) {
                        // Filter 1
                        if self.selectedPack?.filters[0] != nil {
                            PackCellView(
                                image: (self.selectedPack?.filters[0].photo)!,
                                name: (self.selectedPack?.filters[0].name)!)
                        }
                        // Filter 2
                        if self.selectedPack?.filters[1] != nil {
                            PackCellView(
                                image: (self.selectedPack?.filters[1].photo)!,
                                name: (self.selectedPack?.filters[1].name)!)
                        }
                        // Filter 3
                        if self.selectedPack?.filters[0] != nil {
                            PackCellView(
                                image: (self.selectedPack?.filters[2].photo)!,
                                name: (self.selectedPack?.filters[2].name)!)
                        }
                    }

                    VStack {
                        TextImageButton(
                            title: "@\(self.selectedPack?.instagram ?? "")",
                            image: "instagram-icon",
                            action: { self.openInstagram() })
                            .padding(.top, 30)

                        TextImageButton(
                            title: self.aPurchasedPack ? "Installed pack" : "Buy for \(self.selectedPack?.price ?? "")",
                            image: self.aPurchasedPack ? "pack-check" : "dollar-icon",
                            color: self.aPurchasedPack ? Color.splashColor.opacity(0.8) : Color.blueColor.opacity(0.1),
                            textColor: self.aPurchasedPack ? Color.white.opacity(0.7) : Color.blueColor,
                            action: {
                                if !self.aPurchasedPack {
                                    self.purchasePack()
                                }
                        })

                        TextButton(
                            title: "Close",
                            textColor: Color.white.opacity(0.8),
                            width: 100,
                            height: 40,
                            action: {
                                self.contentOffset = CGPoint(x: 0, y: 0)
                                self.cardCloseAnimations()
                        })
                            .padding(.top, 20)
                    }

                    Spacer().frame(height: isIPhoneX ? 120 : 70)
                }
                .animation(nil)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct PackCard_Previews: PreviewProvider {
    static var previews: some View {
        PackCard(state: AppState(), selectedPack: .constant(AppState().selectedPack))
    }
}




