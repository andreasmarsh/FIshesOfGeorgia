//
//  hucLauncher.swift
//  Find My Fish Beta
//
//  Created by NMI Capstone on 11/11/21.
//

import SwiftUI
import Foundation
import WebKit // <-- the cool part

// loads HUC Map
struct hucLauncher: View {
    @Binding var exit: Bool

    var body: some View {
        // set up url
        let url = "https://fishesofgeorgia.uga.edu/images/supplement/huc8_name.pdf"
        
        // reformat spaces to be -'s
        let urlString:String = url.replacingOccurrences(of: " ", with: "-")
        
        // display url
        webPlayer(link: urlString)
    }
}

// what actually happens when webPlayer is called, loads card over current view
struct webPlayer : UIViewRepresentable {
    var link : String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: link) else {
            return WKWebView()
        }
        let controller = WKWebView()
        let request = URLRequest(url: url)
        controller.load(request)
        return controller
    }
    func updateUIView(_ uiView: webPlayer.UIViewType, context: UIViewRepresentableContext<webPlayer>) {
    }
}

