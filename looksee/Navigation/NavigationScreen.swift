//
//  NavigationScreen.swift
//  looksee
//
//  Created by Robert Malko on 11/14/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI

struct NavigationScreen: View {
    let state = AppState()
    @State var selectedIndex: Int = 0

    var body: some View {
        return AnyView(
            ZStack {
                UIKitTabView(
                    [
                        UIKitTabView.Tab(StoreScreen(state: state)),
                        UIKitTabView.Tab(LibraryScreen(state: state)),
                        UIKitTabView.Tab(SettingsScreen(state: state))
                    ],
                    TabBar(
                        selectedIndex: $selectedIndex,
                        state: state
                    ),
                    $selectedIndex
                )
                NotificationCard(state: state)
        })
    }
}

#if DEBUG
struct NavigationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationScreen()
    }
}
#endif
