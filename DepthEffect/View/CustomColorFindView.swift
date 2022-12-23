//
//  CustomColorFindView.swift
//  DepthEffect
//
//  Created by Md Maruf Prodhan on 23/12/22.
//

import SwiftUI

struct CustomColorFindView<Content: View>: UIViewRepresentable {
    @EnvironmentObject var lockScreenModel : LockscreenModel
    var content: Content
    var onLoad:(UIView)->()
    init(@ViewBuilder content:@escaping()->Content,onLoad:@escaping(UIView)->()){
        self.content = content()
        self.onLoad = onLoad
    }
    func makeUIView(context: Context) -> some UIView {
        let size = UIApplication.shared.screenSize()
        let host = UIHostingController(rootView: content.frame(width:size.width,height:size.height)
            .environmentObject(lockScreenModel)
        )
        host.view.frame = CGRect(origin: .zero, size: size)
        return host.view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            onLoad(uiView)
        }
    }
    
    
}
