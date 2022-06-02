//
//  OnboardingScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 11/17/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import Photos

struct OnboardingScreen: View {
    @ObservedObject var state: AppState
    @State private var pulsate = false
    @State var showPackOne = true
    @State var showPackTwo = false
    @State var showPackThree = false
    @State var showPackFour = false
    @State var showPackFive = false
    @State var showPackSix = false

    var packOne: OnboardingPack = OnboardingPackData[0]
    var packTwo: OnboardingPack = OnboardingPackData[1]
    var packThree: OnboardingPack = OnboardingPackData[2]
    var packFour: OnboardingPack = OnboardingPackData[3]
    var packFive: OnboardingPack = OnboardingPackData[4]
    var packSix: OnboardingPack = OnboardingPackData[5]

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
    //Note: This animation logic should be done better

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            ZStack {
                OnboardingBackground(avatar: packOne.avatar, name: packOne.name, image: packOne.image)
                    .opacity(showPackOne ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
                OnboardingBackground(avatar: packTwo.avatar, name: packTwo.name, image: packTwo.image)
                    .opacity(showPackTwo ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
                OnboardingBackground(avatar: packThree.avatar, name: packThree.name, image: packThree.image)
                    .opacity(showPackThree ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
                OnboardingBackground(avatar: packFour.avatar, name: packFour.name, image: packFour.image)
                    .opacity(showPackFour ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
                OnboardingBackground(avatar: packFive.avatar, name: packFive.name, image: packFive.image)
                    .opacity(showPackFive ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
                OnboardingBackground(avatar: packSix.avatar, name: packSix.name, image: packSix.image)
                    .opacity(showPackSix ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8))
            }

            VStack(spacing: 2) {
                ZStack {
                    LinearGradient(gradient:
                        Gradient(colors:
                            [Color.black.opacity(0.3),
                             Color.black.opacity(0.8)]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .frame(width: screenWidth, height: screenHeight - 324, alignment: .center)
                    VStack {
                        Spacer()
                        Image("looksee-logo")
                            .padding(.bottom, 12)
                        Text("Edit your photos with filters made by top creators.")
                            .modifier(TextModifier(color: Color.white.opacity(0.7)))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.horizontal, 50)
                            .padding(.bottom, 30)
                        Spacer().frame(height: 25)
                    }
                }
                ZStack {
                    Spacer().frame(width: screenWidth, height: 320)
                    VStack  {
                        ZStack {
                            OnboardingPackAvatar(avatar: packOne.avatar)
                                .scaleEffect(showPackOne ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackOne ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))

                            OnboardingPackAvatar(avatar: packTwo.avatar)
                                .scaleEffect(showPackTwo ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackTwo ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))

                            OnboardingPackAvatar(avatar: packThree.avatar)
                                .scaleEffect(showPackThree ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackThree ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))

                            OnboardingPackAvatar(avatar: packFour.avatar)
                                .scaleEffect(showPackFour ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackFour ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))

                            OnboardingPackAvatar(avatar: packFive.avatar)
                                .scaleEffect(showPackFive ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackFive ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))

                            OnboardingPackAvatar(avatar: packSix.avatar)
                                .scaleEffect(showPackSix ? 1 : 0.6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                .opacity(showPackSix ? 1 : 0)
                                .animation(.easeInOut(duration: 0.3))
                        }
                        Spacer()
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            self.state.isAnimatingOnboarding = false
                            UserDefaults.timesOnboardingShown = UserDefaults.timesOnboardingShown + 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.state.isShowingOnboarding = false
                            }
                        }) {
                            ZStack {
                                Color.white.opacity(0.2)
                                    .frame(width: 260, height: 64, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                Text("View filter packs")
                                    .modifier(TextModifier(size: 22))
                            }
                            .scaleEffect(self.pulsate ? 1 : 0.98)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).speed(1.5))
                            .onAppear() {
                                self.pulsate.toggle()
                            }
                        }
                        .buttonStyle(ButtonBounceLight())
                        .padding(.bottom, 10)

                        HStack (spacing: 8) {
                            Text("terms")
                                .modifier(TextModifier(size: 15, font: Font.textaAltHeavy, color: Color.white.opacity(0.4)))
                                .onTapGesture {
                                    self.openTerms()
                            }
                            Text("&")
                                .modifier(TextModifier(size: 15, font: Font.textaAltBold, color: Color.white.opacity(0.4)))
                                .padding(.top, 1)
                            Text("privacy")
                                .modifier(TextModifier(size: 15, font: Font.textaAltHeavy, color: Color.white.opacity(0.4)))
                                .onTapGesture {
                                    self.openPrivacy()
                            }
                        }
                        .frame(height: 20)
                        Spacer().frame(height: isIPhoneX ? 70 : 60)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .frame(height: screenHeight - 20)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black, radius: 20, x: 0, y: -10)
        .onAppear() {
            self.showPackOne = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showPackOne = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.showPackTwo = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showPackTwo = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.showPackThree = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.showPackThree = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.showPackFour = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.showPackFour = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            self.showPackFive = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                self.showPackFive = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    self.showPackSix = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        self.showPackSix = false
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                            self.showPackOne = true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(state: AppState())
    }
}

struct OnboardingBackground: View {
    let avatar: String
    let name: String
    let image: String

    var body: some View {
        VStack(spacing: 2) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screenWidth, height: screenHeight - 324)
                .animation(nil)
                .clipped()
            ZStack {
                Image(avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth, height: 320)
                    .blur(radius: 40)
                    .overlay(
                        Color.black
                            .opacity(0.4)
                )
                    .clipped()
                VStack  {
                    Spacer().frame(width: 56, height: 56)
                    Text(name)
                        .modifier(TextModifier(size: 17, font: Font.textaAltBold, color: Color.white.opacity(0.7)))
                        .frame(width: screenWidth)
                    Spacer().frame(height: 110)
                }
                .padding(.top, 25)
                .padding(.bottom, 90)
            }
        }
        .frame(height: screenHeight - 20)
    }
}

struct OnboardingPackAvatar: View {
    let avatar: String
    var body: some View {
        Image(avatar)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 0)
    }
}


struct OnboardingPack: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let image: String

}

let OnboardingPackData = [
    OnboardingPack(name: "Simone Brahmante", avatar: "SimoneBrahmante", image: "SimoneBrahmante-1"),
    OnboardingPack(name: "Jenah Yamamoto", avatar: "JenahYamamoto", image: "JenahYamamoto-2"),
    OnboardingPack(name: "13th Witness", avatar: "ThirteenWitness", image: "ThirteenWitness-1"),
    OnboardingPack(name: "Bethany Marie", avatar: "BethanyMarie", image: "BethanyMarie-3"),
    OnboardingPack(name: "Matt Crump", avatar: "MattCrump", image: "MattCrump-1"),
    OnboardingPack(name: "Shea Marie", avatar: "SheaMarie", image: "SheaMarie-3")
]


