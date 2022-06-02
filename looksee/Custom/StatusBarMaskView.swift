//
//  StatusBarMaskView.swift
//  looksee
//
//  Created by Robert Malko on 11/17/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct StatusBarMaskView: View {
    var body: some View {

        ZStack {
            LinearGradient(gradient: Gradient(colors: [ Color.black.opacity(0.8), Color.black.opacity(0) ]),
                           startPoint: .top,
                           endPoint: .bottom
            ).frame(width: screenWidth, height: isIPhoneX ? 64 : 30, alignment: .center)
            Spacer()
        }
        .frame(
            minWidth: 0,
            idealWidth: nil,
            maxWidth: .infinity,
            minHeight: 0,
            idealHeight: nil,
            maxHeight: .infinity,
            alignment: .top
        )
            .allowsHitTesting(false)
            .edgesIgnoringSafeArea(.top)
    }

}

struct StatusBarMaskView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarMaskView()
    }
}
