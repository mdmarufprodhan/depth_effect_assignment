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
            .environmentObject(lockScreenModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
