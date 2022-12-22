//
//  Home.swift
//  DepthEffect
//
//  Created by Md Maruf Prodhan on 22/12/22.
//

import SwiftUI
import PhotosUI

struct Home: View {
    @EnvironmentObject var lockScreen : LockscreenModel
    var body: some View {
        VStack {
            if let compressedImage = lockScreen.compresedImage {
                Image(uiImage: compressedImage)
                    .resizable()
                    .aspectRatio(contentMode:.fit)
            }
            else{
                PhotosPicker(selection: $lockScreen.pickedItem,matching: .images,preferredItemEncoding: .automatic,photoLibrary: .shared()) {
                    VStack(spacing:10){
                        Image(systemName: "plus.viewfinder")
                            .font(.largeTitle)
                        Text("Add Image")
                    }
                    .foregroundColor(.primary)
                }
               
            }
        }
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
