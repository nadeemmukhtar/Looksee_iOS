//
//  UserDefaults.swift
//  looksee
//
//  Created by Justin Spraggins on 11/19/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let timesRateShownKey: String = "times rate card"
    static var timesRateShown: Int {
        get {
            return UserDefaults.standard.integer(forKey: timesRateShownKey)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: timesRateShownKey)
        }
    }

    static let timesOnboardingShownKey: String = "times onboarding"
       static var timesOnboardingShown: Int {
           get {
               return UserDefaults.standard.integer(forKey: timesOnboardingShownKey)
           }
           set(newValue) {
               UserDefaults.standard.set(newValue, forKey: timesOnboardingShownKey)
           }
       }

    static let timesNotificationShownKey: String = "times notification"
         static var timesNotificationShown: Int {
             get {
                 return UserDefaults.standard.integer(forKey: timesNotificationShownKey)
             }
             set(newValue) {
                 UserDefaults.standard.set(newValue, forKey: timesNotificationShownKey)
             }
         }

    static func removeUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

}
