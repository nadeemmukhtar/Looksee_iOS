//
//  BannerView.swift
//  looksee
//
//  Created by Justin Spraggins on 2/18/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct NotificationCard: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack {
            ZStack {
                BackgroundBlurView(style: .systemThinMaterial)
                    .background(Color.blurBackgroundColor)
                    .frame(width: 200, height: 50, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.4), radius: 30, x: 0, y: 5)
                HStack (spacing: 0){
                    Image("check-notification")
                    Spacer()
                    Text("Pack installed").modifier(TextModifier(size: 19))
                        .padding(.top, 4)
                    Spacer()
                }
                    .padding()
                    .frame(width: 200, height: 50, alignment: .center)
            }
            .padding(.top, 10)
            Spacer()
        }
        .offset(y: self.state.showNotification ? 0 : -200)
        .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10, initialVelocity: 0))
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard(state: AppState())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
