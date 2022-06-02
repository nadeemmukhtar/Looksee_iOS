//
//  CodyExtensions.swift
//  looksee
//
//  Created by Robert Malko on 11/16/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first

        return keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController()
        }

        if self.presentedViewController == nil { return self }

        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }

        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }

        return self.presentedViewController!.topMostViewController()
    }
}
