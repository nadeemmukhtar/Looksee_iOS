//
//  HostingController.swift
//  looksee
//
//  Created by Justin Spraggins on 11/12/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class HostingController: UIHostingController<NavigationScreen> {

    private var state: AppState {
          return rootView.state
      }

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if UserDefaults.timesOnboardingShown == 0 {
        self.state.isShowingOnboarding = true
    }
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
}

override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
}

override var prefersStatusBarHidden: Bool {
    return false
}

}
