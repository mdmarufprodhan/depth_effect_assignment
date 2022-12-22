//
//  LockScreenModel.swift
//  DepthEffect
//
//  Created by Md Maruf Prodhan on 22/12/22.
//

import SwiftUI
import PhotosUI

class LockscreenModel: ObservableObject{
    //Mark : Image Picker Properties
    @Published var pickedItem:PhotosPickerItem?
    @Published var compresedImage : UIImage?
    
}
