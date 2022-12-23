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
        Home()
        //Marks : Scaling
            .gesture(
                MagnificationGesture(minimumScaleDelta:0.01)
                    .onChanged({ value in
                        lockScreenModel.scale = value + lockScreenModel.lastScale
                    })
                    .onEnded({_ in
                        if lockScreenModel.scale<1{
                            withAnimation(.easeOut(duration: 0.15)){
                                lockScreenModel.scale = 1
                            }
                        }
                        lockScreenModel.lastScale = lockScreenModel.scale-1
                    })
            )
            .environmentObject(lockScreenModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
