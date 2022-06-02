//
//  LibraryScreen.swift
//  looksee
//
//  Created by Justin Spraggins on 11/12/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import Photos
import SwiftUI

struct LibraryScreen: View {
    @ObservedObject var state: AppState
    @State private var hasPhotoAccess: Bool =
        CodyPhotoKit.Permissions.isVerified()
    @State private var selectedImage: UIImage?
    @State private var selectedImageFrame: CGRect = .zero

    @State private var showEditScreen = false

    // animations
    @State private var timer: Timer?

    init(state: AppState) {
        self.state = state
        state.fetchPhotoAlbums()
    }

    private func askForPhotosPermission() {
        self.hasPhotoAccess = CodyPhotoKit.Permissions.isVerified()
        state.fetchPhotoAlbums()
    }

    private func onImageTap(asset: PHAsset, image: UIImage?, frame: CGRect) {
//        self.state.isAnimatingPhoto = false
//        self.selectedImage = image
//        self.selectedImageFrame = frame
//        withAnimation(.spring()) {
//            self.state.isAnimatingPhoto = true
//            self.showEditScreen = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                self.state.isShowingEdit = true
//            }
//        }
//        
        self.getMaxSizeImage(asset: asset) { image in
            self.selectedImage = image
            self.selectedImageFrame = frame
            DispatchQueue.main.async {
                self.state.isAnimatingPhoto = false
                withAnimation(.spring()) {
                    self.state.isAnimatingPhoto = true
                    self.showEditScreen = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.state.isShowingEdit = true
                    }
                }
            }
        }
    }
    
    private func getMaxSizeImage(asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode =
            PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isNetworkAccessAllowed = false
        options.isSynchronous = false
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: options,
            resultHandler: { (image, info) in
                completion(image)
            }
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                if self.state.hasPhotoAccess {
                        PhotosCollectionView(
                                           albums: self.$state.albums,
                                           selectedAlbum: self.$state.selectedAlbum,
                                           selectedAlbumId: self.$state.selectedAlbumId,
                                           topOffset: isIPhoneX ? 10 : 5,
                                           onImageTap: self.onImageTap
                                       )
                                           .edgesIgnoringSafeArea(.all)

//                    ImageButton(image: "library-refresh",
//                                width: 44,
//                                height: 44,
//                                corner: 22,
//                                blur: true,
//                                action: {
//                                    self.state.fetchPhotoAlbums()
//                    })
//                        .padding(.bottom, geometry.size.height - 80)
//                        .padding(.trailing, geometry.size.width - 75)
//                        .opacity(self.state.hideRefresh ? 0 : 1)
//                        .animation(.easeInOut(duration: 0.3))
//                        .scaleEffect(self.state.hideRefresh ? 0.8 : 1)
//                        .animation(.spring())
                } else {
                    ZStack {
                        LibraryAccessView()
                            .frame(height: screenHeight)
                        VStack {
                            Spacer()
                            TextImageButton(
                                title: "Allow access to photos",
                                color: Color.buttonColorLight,
                                action:{
                                    //TODO: If user allows access --> show the photos and albums
                                    self.askForPhotosPermission() })
                                .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 0)
                            Spacer().frame(height: isIPhoneX ? 180 : 140)
                        }
                    }
                }
                if self.selectedImage != nil {
                    ZStack {

                        Image(uiImage: self.selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: self.selectedImageFrame.width,
                                height: self.selectedImageFrame.height
                        )
                            .clipped()
                            .blur(radius: self.state.isAnimatingPhoto ? 5 : 0)
                            .overlay(
                                Rectangle()
                                    .foregroundColor(Color.black.opacity(self.state.isAnimatingPhoto ? 0.6 : 0))
                                    .animation(.linear(duration: 0.3))
                        )
                            .scaleEffect(self.state.isAnimatingPhoto ? 15 : 1)
                            .offset(
                                x: -((geometry.size.width / 2) - self.selectedImageFrame.midX),
                                y: -((geometry.size.height / 2) - self.selectedImageFrame.midY + (isIPhoneX ? 44 : 20))
                        )

                        if self.showEditScreen {
                            EditScreen(state: self.state, selectedImage: self.$selectedImage,
                                       action: {
                                        self.state.selectedFilters.removeAll()
                                        self.state.isShowingEdit = false

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                self.state.isAnimatingPhoto = false
                                            }
                                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                                self.selectedImage = nil
                                                self.showEditScreen = false
                                                self.timer?.invalidate()
                                            }
                                        }
                            })
                        }

                        if self.state.isShowingSocialShare {
                            EditShareScreen(state: self.state, action: {

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        self.state.isAnimatingPhoto = false
                                        self.state.socialShareUp = false
                                    }
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                        self.selectedImage = nil
                                        self.timer?.invalidate()
                                    }
                                }
                                withAnimation(.easeOut(duration: 0.3)) {
                                    self.state.socialShareCenter = false
                                    self.state.socialShareUp = true
                                }
                            })
                                .opacity(self.state.socialShareCenter ? 1 : 0)
                                .offset(x: 0, y:
                                    self.state.socialShareCenter ? 0 :
                                        self.state.socialShareUp ? -screenHeight :
                                    screenHeight )
                                .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 16, initialVelocity: 0))
                                .transition(.move(edge: .bottom))

                        }

                    }
                }
                StatusBarMaskView()
                    .opacity(self.state.isAnimatingPhoto ? 0 : 1)
                    .animation(Animation.easeOut(duration: 0.3))
                    .transition(.move(edge: .top))
            }
        }
        .onAppear {
            self.state.isAnimatingPhoto = false
            self.selectedImage = nil
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        return LibraryScreen(state: state)
    }
}
