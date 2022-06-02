//
//  TabBar.swift
//  looksee
//
//  Created by Robert Malko on 11/14/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedIndex: Int
    @ObservedObject var state: AppState
    @State var initialState = true

    func onTap(index: Int) -> (() -> Void) {
        func update() { self.selectedIndex = index }
        return update
    }

    var hideTabBar: Bool {
        self.state.isAnimatingPhoto || self.state.isAnimatingTabBar || self.state.isShowingOnboarding || self.initialState
    }

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                BackgroundBlurView(style: .systemMaterial)
                    .background(Color.blurBackgroundColor)
                    .frame(width: screenWidth, height: 120, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                    .shadow(color: Color.shadowColor.opacity(0.8), radius: 20, x: 0, y: -10)

                ZStack {
                    Rectangle()
                        .frame(width: 248, height: 56)
                        .foregroundColor(Color.black.opacity(0.2))
                        .cornerRadius(21)
                    Rectangle()
                        .frame(width: 61, height: 45)
                        .foregroundColor(Color.black)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .offset(x: selectedIndex == 0 ? -84 : selectedIndex == 1 ? 0 : 84)
                        .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))

                    HStack(alignment: .center) {
                        StoreTabItem(
                            image: "tab-store",
                            onTap: onTap(index: 0),
                            isSelected: selectedIndex == 0
                        )
                        Spacer()
                        TabItem(
                            image: "tab-plus",
                            onTap: onTap(index: 1),
                            isSelected: selectedIndex == 1
                        ).colorMultiply(Color.primaryTextColor)
                        Spacer()
                        TabItem(
                            image: "tab-settings",
                            onTap: onTap(index: 2),
                            isSelected: selectedIndex == 2
                        ).colorMultiply(Color.primaryTextColor)
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 248, height: 56)
                }
                .padding(.bottom, isIPhoneX ? 15 : 35)

            }
            .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
            .offset(y: hideTabBar ? 125 : (isIPhoneX ? 5 : 35))
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.initialState = false
            }
        }
    }
}

struct TabItem: View {
    let image: String
    let onTap: () -> Void
    let isSelected: Bool

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            self.onTap()
        }) {
            Image(image)
                .frame(width: 60, height: 82, alignment: .center)
                .opacity(isSelected ? 1 : 0.5)
        }
        .buttonStyle(ButtonBounceHeavy())
    }
}

struct StoreTabItem: View {
    let image: String
    let onTap: () -> Void
    let isSelected: Bool

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            self.onTap()
        }) {
            Image(image)
                .frame(width: 60, height: 82, alignment: .center)
                .saturation(isSelected ? 1 : 0.5)
        }
        .buttonStyle(ButtonBounceHeavy())
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        return TabBar(selectedIndex: .constant(0), state: state)
    }
}
