//
//  ContentView.swift
//  webview-tool
//
//  Created by Krunal  on 2024-03-01.
//

import SwiftUI
import WebKit

struct ContentView: View {
    private let url = "https://mortgage-calculator-coral.vercel.app/"
    @State private var showLoading: Bool = false
    
    var body: some View {
        
        VStack {
            WebView(
                url: URL(
                    string: url
                )!,
                showLoading: $showLoading
            ).overlay(
                showLoading ? ProgressView(
                    "Loading..."
                ) : nil
            )
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var showLoading: Bool
    
    func makeUIView(
        context: Context
    ) -> WKWebView {
        let webView = WKWebView()
        
        let request = URLRequest(
            url: url
        )
        webView.load(
            request
        )
        return webView
    }
    
    func updateUIView(
        _ uiView: UIViewType,
        context: Context
    ) {
        
    }
    
    func makeCoordinator() -> WebviewCoordinator {
        WebviewCoordinator(
            didStart: {
                showLoading = true
        },
           didFinish: {
               showLoading = false
        })
    }
}

class WebviewCoordinator: NSObject, WKNavigationDelegate {
    var didStart: () -> Void
    var didFinish: () -> Void
    
    init(
        didStart: @escaping () -> Void,
        didFinish: @escaping () -> Void
    ) {
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        didStart()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        didFinish()
    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        print(
            "Webview navigation failed",
            error
        )
    }
}

#Preview {
    ContentView()
}
