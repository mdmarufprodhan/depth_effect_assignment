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
                GeometryReader{proxy in
                    let size = proxy.size
                    Image(uiImage: compressedImage)
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: size.width,height: size.height)
                        .scaleEffect(lockScreen.scale)
                        .overlay(
                            TimeView()
                                .environmentObject(lockScreen)
                        )
                    
                }
            }
            else{
                PhotosPicker(selection: $lockScreen.pickedItem,matching: .images,preferredItemEncoding: .automatic,photoLibrary: .shared()) {
                    VStack(spacing:10){
                        Image(systemName: "iphone.gen2")
                            .font(.largeTitle)
                        Text("Add Image")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment:.topLeading){
            Button {
                withAnimation (.easeOut){
                    lockScreen.compresedImage = nil
                }
            } label: {
                Text("Cancel")
            }
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical,8)
            .foregroundColor(.primary)
            .background{
                Capsule()
                    .fill(.ultraThinMaterial)
            }
            .padding(16)
            .opacity(lockScreen.compresedImage == nil ? 0:1)
        }
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//Marks : Time view
struct TimeView : View{
    @EnvironmentObject var lockScreenModel : LockscreenModel
    var body: some View{
        HStack(spacing:6){
            Text(Date.now.convertToString(.hour))
                .font(.system(size: 95))
                .fontWeight(.semibold)
            //marks: dot
            VStack(spacing:10){
                Circle()
                    .fill(.white)
                    .frame(width: 15,height: 15)
                Circle()
                    .fill(.white)
                    .frame(width: 15,height: 15)
            }
            Text(Date.now.convertToString(.minute))
                .font(.system(size: 95))
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
        .padding(.top,100)
    }
}
// Date to string conversion
enum DateFormat: String{
    case hour = "hh"
    case minute = "mm"
    case seconds = "ss"
}
extension Date{
    func convertToString(_ format:DateFormat)->String{
        let formater = DateFormatter()
        formater.dateFormat = format.rawValue
        return formater.string(from: self)
    }
}
