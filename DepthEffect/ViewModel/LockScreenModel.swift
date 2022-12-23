//
//  LockScreenModel.swift
//  DepthEffect
//
//  Created by Md Maruf Prodhan on 22/12/22.
//

import SwiftUI
import PhotosUI
import SDWebImage
import Vision
import CoreImage

class LockscreenModel: ObservableObject{
    
    //Mark : Image Picker Properties
    @Published var pickedItem:PhotosPickerItem? {
        didSet{
            extractImage()
        }
    }
    @Published var compresedImage : UIImage?
    //Mark : Scaling Properties
    @Published  var scale : CGFloat = 1
    @Published var lastScale : CGFloat = 0
    
    func extractImage(){
        if let pickedItem {
            Task{
                guard let imageData = try? await pickedItem.loadTransferable(type:Data.self) else {return}
                //mark: resize Image To Phones size*2
                //so that Memory will be Preserved
                let size = await UIApplication.shared.screenSize()
                let image = UIImage(data: imageData)?.sd_resizedImage(with: CGSize(width:size.width*2, height: size.height*2), scaleMode:.aspectFill)
                await MainActor.run(body: {
                    self.compresedImage = image
                })
            }
        }
    }
    //Mark : Person Segmentation Using Vision
    func segmentPersonOnImage(){
        
    }
}
extension UIApplication{
    func screenSize()->CGSize{
        guard let window = connectedScenes.first as? UIWindowScene else {return.zero}
        return window.screen.bounds.size
    }
}
