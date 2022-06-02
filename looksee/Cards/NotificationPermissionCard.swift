//
//  NotificationPermissionCard.swift
//  looksee
//
//  Created by Justin Spraggins on 3/2/20.
//  Copyright © 2020 Extra Visual, Inc. All rights reserved.
//

import SwiftUI
import OneSignal

struct NotificationPermissionCard: View {
    @ObservedObject var state: AppState
    
    let cardHeight: CGFloat = 420

    private func cardCloseAnimations() {
        self.state.isAnimatingTabBar = false
        self.state.showBlurCard = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.state.notificationAccess = false
        }
    }

    var body: some View {
        ZStack {
            BackgroundBlurView(style: .systemThinMaterialDark)
                .background(Color.blurBackgroundColor)
                .frame(width: screenWidth, height: cardHeight, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                .shadow(color: Color.shadowColor.opacity(0.8), radius: 20, x: 0, y: -10)
            VStack (spacing: 0) {
                HStack (alignment: .top) {
                    Spacer().frame(width: 50)
                    Spacer()
                    Image("looksee-alert")
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 0)
                    Spacer()
                    TextButton(title: "Skip", textColor: Color.white.opacity(0.3), textSize: 17, width: 70, height: 36, background: Color.black.opacity(0.2),
                               action: {
                                self.cardCloseAnimations()
                    })
                        .padding(.top, 10)
                }
                .padding(.top, 15)
                .padding(.horizontal, 25)

                Text("Allow notifications to get special offers and to be notified when new filter packs release.")
                    .modifier(TextModifier(color: Color.white.opacity(0.8)))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .frame(width: screenWidth - 60)

                Spacer()
                TextButton(title: "Allow", width: 170, height: 54, background: Color.white.opacity(0.2),
                           action: {
                            OneSignal.promptForPushNotifications(userResponse: { accepted in
                                self.cardCloseAnimations()
                                UserDefaults.timesNotificationShown = UserDefaults.timesNotificationShown + 1
                            })
                })
                    .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 0)
                    .padding(.bottom, 75)
            }
            .frame(width: screenWidth, height: cardHeight)
        }
    }
}

struct NotificationPermissionCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissionCard(state: AppState())
            .previewLayout(.sizeThatFits)
            .padding()

    }
}
