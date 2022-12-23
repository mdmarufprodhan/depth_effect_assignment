//
//  ContentView.swift
//  DepthEffect
//
//  Created by Md Maruf Prodhan on 22/12/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var lockScreenModel : LockscreenModel = .init()
    var body: some View {
        CustomColorFindView(content: {
            Home()
        },onLoad: { view in
            lockScreenModel.view = view
        })
        .overlay(content: {
            TimeView()
                .environmentObject(lockScreenModel)
                .opacity(lockScreenModel.placeTextAbove ? 1:0)
        })
        .ignoresSafeArea()
        .environmentObject(lockScreenModel)
        //Marks : Scaling
            .gesture(
                MagnificationGesture(minimumScaleDelta:0.01)
                    .onChanged({ value in
                        lockScreenModel.scale = value + lockScreenModel.lastScale
                        lockScreenModel.verifyScreenColor()
                    })
                    .onEnded({_ in
                        if lockScreenModel.scale<1{
                            withAnimation(.easeOut(duration: 0.15)){
                                lockScreenModel.scale = 1
                            }
                        }
                        lockScreenModel.lastScale = lockScreenModel.scale-1
                        DispatchQueue.main.asyncAfter(deadline:.now()+0.2){
                            lockScreenModel.verifyScreenColor()
                        }
                    })
            )
            .environmentObject(lockScreenModel)
            .onChange(of:lockScreenModel.onLoad) { newValue in
                if newValue{lockScreenModel.verifyScreenColor()}
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
