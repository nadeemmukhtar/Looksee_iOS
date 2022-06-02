//
//  AppState.swift
//  looksee
//
//  Created by Robert Malko on 11/16/19.
//  Copyright © 2019 Extra Visual, Inc.. All rights reserved.
//

import Combine
import UIKit

class AppState: ObservableObject {
    @Published var albums: [CodyPhotoKit.Album] = []
    @Published var hasPhotoAccess = false
    
    @Published var isAnimatingPhoto = false
    @Published var isAnimatingTabBar = false
    @Published var isAnimatingFilters = false
    @Published var isFilterSelected = false
    @Published var isShowingOnboarding = false
    @Published var isAnimatingOnboarding = false
    @Published var isShowingPack = false
    @Published var isShowingSubscription = false
    @Published var animateCardOpen = false
    @Published var showBlurCard = false
    @Published var hideRefresh = false
    @Published var notificationAccess = false

    @Published var showNotification = false
    @Published var purchaseNotification = false
    @Published var purchasedPack = false

    @Published var isShowingEdit = false
    @Published var isShowingSocialShare = false
    @Published var socialShareCenter = false
    @Published var socialShareUp = false
    @Published var socialShareDown = false
    
    let packWillChange = PassthroughSubject<Bool, Never>()

       @Published var dragCard = false

    @Published var animateScrollView = false
    
    @Published var packSelected = false

    var stickerImage: UIImage?
    var filteredImage: UIImage?
    var filterName: String = "No Filter"
    var filterInstagram: String = "withLooksee"
    var filterCover: String = "stories-looksee"
    
    var filteredText: String = ""
    var selectedFilteredText: String = ""
    
    var sPurchasedPacks = PurchasedPacks
    
    @Published var FileImages: [FileImage] = []
    @Published var selectedTools = ToolsData
    
    @Published var selectedPack: FilterPack?
    @Published var selectedFilters: [PhotoFilter] = []

    @Published var selectedAlbum: CodyPhotoKit.Album?
    @Published var selectedAlbumId: String? {
        willSet {
            if newValue != selectedAlbumId {
                self.updateSelectedAlbum(albumId: newValue)
            }
        }
    }
    var cachedImages = [String: UIImage]()

    func fetchPhotoAlbums() {
        CodyPhotoKit.Albums.fetch { photoAlbums in
            DispatchQueue.main.async {
                self.albums = photoAlbums
                self.hasPhotoAccess = CodyPhotoKit.Permissions.isVerified()
                self.selectedAlbumId = photoAlbums.first?.id
                self.fetchCoverPhotosForPhotoAlbums()
            }
        }
    }

    private func fetchCoverPhotosForPhotoAlbums() {
        DispatchQueue.global(qos: .background).async {
            self.albums.forEach { photoAlbum in
                photoAlbum.fetchCoverPhoto(
                    targetSize: CGSize.init(width: 200, height: 200)
                ) { photo in
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                        photoAlbum.coverPhoto = photo
                    }
                }
            }
        }
    }

    private func updateSelectedAlbum(albumId: String?) {
        self.selectedAlbum = self.albums.first(where: {
            $0.id == albumId
        })
        if self.selectedAlbum?.photos.count == 0 {
            self.selectedAlbum?.fetchPhotos()
        }
    }
}
