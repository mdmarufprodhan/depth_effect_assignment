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
import CoreImage.CIFilterBuiltins

class LockscreenModel: ObservableObject{
    
    //Mark : Image Picker Properties
    @Published var pickedItem:PhotosPickerItem? {
        didSet{
            extractImage()
        }
    }
    @Published var compresedImage : UIImage?
    @Published var detectedPerson :UIImage?
    //Mark : Scaling Properties
    @Published  var scale : CGFloat = 1
    @Published var lastScale : CGFloat = 0
    @Published var textReact: CGRect = .zero
    @Published var view : UIView = .init()
    @Published  var placeTextAbove : Bool = false
    @Published var onLoad: Bool = false
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
                    segmentPersonOnImage()
                })
            }
        }
    }
    //Mark : Person Segmentation Using Vision
    func segmentPersonOnImage(){
        guard let   image = compresedImage?.cgImage else {return}
        let request = VNGeneratePersonSegmentationRequest()
        request.usesCPUOnly = true
        let task = VNImageRequestHandler(cgImage: image)
        do {
            try task.perform([request])
//            if let result = request.results?.first{
//                let buffer = result.pixelBuffer
//            }
            if let result  = request.results?.first{
                let buffer = result.pixelBuffer
                maskWithOriginalImage(buffer: buffer)
                print(buffer)
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    // we need to access mask with original image
    func maskWithOriginalImage(buffer:CVPixelBuffer){
        guard let cgImage = compresedImage?.cgImage else{return}
        let original = CIImage(cgImage: cgImage)
        let mask = CIImage(cvImageBuffer: buffer)
        // scaling property
        let maskX = original.extent.width / mask.extent.width
        let maskY = original.extent.height / mask.extent.height
        
        let resizedMask = mask.transformed(by: CGAffineTransform(scaleX: maskX, y: maskY))
        // filter image
        let filetr = CIFilter.blendWithMask()
        filetr.inputImage = original
        filetr.maskImage = resizedMask
        if let maskImage = filetr.outputImage{
            let context = CIContext()
            guard  let image = context.createCGImage(maskImage, from: maskImage.extent) else {return}
            // here dectecd person image
            self.detectedPerson = UIImage(cgImage: image)
            self.onLoad = true
        }
    }
    
    func verifyScreenColor(){
        let rgba = view.color(at: CGPoint(x: textReact.midX, y: (textReact.minY + 5)))
        print(rgba)
        withAnimation(.easeOut){
            if rgba.0==1 && rgba.1==1 && rgba.2==2 && rgba.3==1{
                placeTextAbove = false
                
            }
            else{
                placeTextAbove = true
            }
            
        }
       
    }
    
}
extension UIView{
    //rgba
    func color(at point : CGPoint)->(CGFloat,CGFloat,CGFloat,CGFloat){
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let  bitMapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData : [UInt8] = [0,0,0,0]
        let context = CGContext(data:&pixelData,width: 1, height: 1, bitsPerComponent:8, bytesPerRow:4, space: colorSpace, bitmapInfo:bitMapInfo.rawValue)
        context!.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        let red  = CGFloat(pixelData[0])/255
        let blue  = CGFloat(pixelData[1])/255
        let gren  = CGFloat(pixelData[2])/255
        let alpha  = CGFloat(pixelData[3])/255
        return (red,gren,blue,alpha)
    }
}
extension UIApplication{
    func screenSize()->CGSize{
        guard let window = connectedScenes.first as? UIWindowScene else {return.zero}
        return window.screen.bounds.size
    }
}
