//
//  SecondWebViewController.swift
//  web-bridge-swift
//
//  Created by 60104968 on 2021/07/23.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import WebKit

class SecondWebViewController: UIViewController, RxFlow.Stepper {

    // ================================================================
    // Member Variable
    // ================================================================
    /// WebView 설정
    //let homepageURL = "http://localhost:8080/javascript-bridge/second.html"
    let homepageURL = "https://jinreol.github.io/javascript-bridge/second.html"
    let exampleInterface = "exampleInteface"

    let steps = PublishRelay<Step>()

    /// 뷰 설정
    private var didSetupConstraints = false


    /// WebView 설정
    private lazy var webView: WKWebView = {
        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: exampleInterface)
        
        // Configuration
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        let url = URL(string: homepageURL)!
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }()

    /// 로딩바
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()

    /// pull to refresh
    private let pullToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        refresh.backgroundColor = .gray
        return refresh
    }()

    // ================================================================
    // ViewController Delegate Function
    // ================================================================
    
    /// 화면 로드 완료
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setWebViewDelegate()
        
        view.setNeedsUpdateConstraints()
        activityIndicator.startAnimating()
    }
    
    /// AutoLayout Constraints를 설정한다.
    override func updateViewConstraints() {
        innerUpdateViewConstraints()
        super.updateViewConstraints()
    }
}

// ================================================================
// UI 처리
// ================================================================
extension SecondWebViewController {

    private func addSubview() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        webView.scrollView.addSubview(pullToRefresh)
    }

    private func innerUpdateViewConstraints() {
        if (!didSetupConstraints) {
            webView.snp.makeConstraints { make in
                make.top.bottom.left.right.equalToSuperview()
            }
            
            activityIndicator.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            didSetupConstraints = true
        }
    }
}

// ================================================================
// Pull To Refresh 처리
// ================================================================
extension SecondWebViewController {
    @objc func updateUI(refresh: UIRefreshControl) {
        print("pull to refresh updateUI")
        refresh.endRefreshing()
        webView.reload()
    }
}

// ================================================================
// WKWebView Delegate 등록
// ================================================================
extension SecondWebViewController {
    private func setWebViewDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}


// ================================================================
// WKScriptMessageHandler: 자바스크립트 수신 처리
// ================================================================
extension SecondWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name:\(message.name)")
        
        if message.name == exampleInterface, let messageBody = message.body as? String {
            print("messageBody:\(messageBody)")
            let data = messageBody.data(using: .utf8)
            let decoder = JSONDecoder()

            if let data = data, let myPerson = try? decoder.decode(WebBrideData.self, from: data) {
                print(myPerson.command)
                print(myPerson.data)
            }
        }
    }
}

// ================================================================
// WKUIDelegate: javascript 팝업 표시
// ================================================================
extension SecondWebViewController: WKUIDelegate {
    
    /// javascript alert 함수가 호출될 때 실행된다.
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("자바스크립트 alert를 표시합니다.")
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
        completionHandler()
    }
    
    /// javascript confirm 함수가 호출될 때 실행된다.
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("자바스크립트 confirm를 표시합니다.")
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "NO", style: .default, handler: { _ in
            completionHandler(false)
        }))
        present(alertController, animated: true)
    }
}

// ================================================================
// WKNavigationDelegate: 접속, 로딩, 완료의 진행상태를 알려준다.
// ================================================================
extension SecondWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("웹뷰가 웹 컨텐츠를 받기 시작할 때 호출됩니다.");
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹 컨텐츠가 웹뷰에서 로드되기 시작할 때 호출됩니다.");
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("웹뷰가 서버 리디렉션을 수신 할 때 호출됩니다.")
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 사설 인증서로 구성된 서버로 접근이 가능합니다.
        print("탐색 허용 여부를 결정합니다.")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 사설 인증서로 구성된 서버로 접근이 가능합니다.
        print("웹뷰가 인증 요청에 응답해야 할 때 호출됩니다.")
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("탐색 중에 오류가 발생하면 호출됩니다.")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("웹보기가 내용을로드하는 동안 오류가 발생하면 호출됩니다.")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("탐색이 완료되면 호출됩니다.")
        activityIndicator.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("웹뷰의 웹 콘텐츠 프로세스가 종료 될 때 호출됩니다.")
    }
    
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //        print("응답이 알려진 후 탐색을 허용할지 또는 취소 할지를 결정합니다.")
    //    }
    //
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
    //        print("instance method")
    //    }
}
