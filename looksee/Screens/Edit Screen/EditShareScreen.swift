//
//  EditShareScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 2/16/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import MessageUI

struct EditShareScreen: View {
    @ObservedObject var state: AppState
    var action: () -> Void
    var socialHeight = screenHeight - (isIPhoneX ? 210 : 170)

    @State private var showingShare = false

    /// The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageDelegate()


    var body: some View {

        VStack {
            Spacer().frame(height: 10)
            HStack {
                VStack {

                    SocialShareButton(image: "share-iMessage", height: socialHeight * 0.3, action: {
                        self.presentMessageCompose()
                    })

                    SocialShareButton(image: "share-instagram", height: socialHeight * 0.3, action: {
                        self.presentInstagramFeed()
                    })

                    SocialShareButton(image: "share-snapchat", height: socialHeight * 0.4, action: {
                        //TODO: Open Snapchat with creative kit
                        self.presentSnapchat()
                    })
                }
                VStack {
                    SocialShareButton(image: "share-more", height: socialHeight * 0.3 + 5, action: {
                        self.showingShare.toggle()
                    })
                        .sheet(isPresented: $showingShare) {
                            ShareSheet(activityItems: [self.state.filteredImage!, self.state.filteredText], excludedActivityTypes: [])
                    }

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        self.presentInstagramStories()
                    }) {
                        ZStack {
                            Color.white.opacity(0.1)
                                .frame(width: screenWidth/2 - 20, height: socialHeight * 0.7 + 5)
                                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            VStack (spacing: 15) {
                                Image("share-stories")
                                Text("IG Stories")
                                    .modifier(TextModifier())
                            }
                        }
                    }
                    .buttonStyle(ButtonBounce())
                }
            }
            TextButton(title: "Done", color: Color.white.opacity(0.1), action: {
                self.action()
            })
                .padding(.top, 10)
            
        }

    }
}

struct EditShareScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditShareScreen(state: AppState(), action: {})
    }
}


struct SocialShareButton: View {
    var image: String
    var height: CGFloat = 200
    var action: () -> Void

    var body: some View {

        Button(action: {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.action()
        }) {
            ZStack {
                Color.white.opacity(0.1)
                    .frame(width: screenWidth/2 - 20, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                Image(image)
            }
        }
        .buttonStyle(ButtonBounce())
    }
}

// MARK: The message part
extension EditShareScreen {
    /// Present Snapchat
    private func presentSnapchat() {
        if let img = self.state.filteredImage  {
            let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            SocialManager.sharedManager.postToSnapchat(image: img, filterName: self.state.filterName, username: self.state.filterInstagram, coverPhoto: self.state.filterCover, vc: vc)
        }
    }
    
    /// Present Instagram
    private func presentInstagramFeed() {
        if let img = self.state.filteredImage {
            let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            SocialManager.sharedManager.postToInstagramFeed(image: img, text: self.state.filteredText, vc: vc)
        }
    }
    
    private func presentInstagramStories() {
        if let img = self.state.filteredImage {
            let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            SocialManager.sharedManager.postToInstagramStories(image: img, filterName: self.state.filterName, username: self.state.filterInstagram, coverPhoto: self.state.filterCover, vc: vc)
        }
    }

    /// Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }

    }

    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        //let vc = UIApplication.shared.keyWindow?.rootViewController
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate

        //TODO: Add filter name and instagram handle of filter pack creator
        /// example: Stay Gold filter by @karrueche #looksee
        composeVC.body = self.state.filteredText
        if let img = self.state.filteredImage, let imgData = img.pngData() {
            composeVC.addAttachmentData(imgData, typeIdentifier: "image/png", filename: "image.png")
        }

        vc?.present(composeVC, animated: true)
    }
}
