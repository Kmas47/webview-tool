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
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        let webView = WebView(
            url: URL(
                string: url
            )!,
            viewModel: viewModel
        )
        
        VStack {
            webView.overlay(
                viewModel.isLoading ? ProgressView(
                    "Loading..."
                ) : nil
            )
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: ViewModel
    
    func makeUIView(
        context: Context
    ) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.showsVerticalScrollIndicator = false
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
        WebviewCoordinator {
            viewModel.isLoading = true
        } didFinish: {
            viewModel.isLoading = false
        }

    }
}

class ViewModel : ObservableObject {
    @Published var isLoading: Bool = true;
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
