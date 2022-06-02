//
//  LookseeImage.swift
//  looksee
//
//  Created by Appcrates_Dev on 2/25/20.
//  Copyright © 2020 Extra Visual, Inc.. All rights reserved.
//

import SwiftUI
import GPUImage

struct LookseeImage: UIViewRepresentable {
    
    var file: String = ""
    var previewImage: UIImage = UIImage(named: "no-photo")!
    
    func makeUIView(context: Context) -> UIView {
        let imageView = GPUImageView()
        let image = previewImage
        
        let picture = GPUImagePicture(image: image, smoothlyScaleOutput: true)
        
        let curveFilter = GPUImageBrightnessFilter()
        curveFilter.brightness = 0.5
        picture?.addTarget(curveFilter)
        
        curveFilter.addTarget(imageView)
        picture?.processImage()
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
