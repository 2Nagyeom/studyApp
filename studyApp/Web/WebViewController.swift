//
//  CalenderViewController.swift
//  studyApp
//
//  Created by NaGyeom Lee on 3/19/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webTextField: UITextField!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var webViewBottom: NSLayoutConstraint!
    
    func loadWebPage( _ url : String) {
        // 인자로 받은 url 을 URL 형으로 선언
        let myUrl = URL(string: url)
        // nil 은 무조건 없다는 조건하에
        let myRequest = URLRequest(url: myUrl!)
        // 웹뷰의 load 메서드를 호출
        myWebView.load(myRequest)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
        loadWebPage("https://invented-zone-8ba.notion.site/8273b9b0aef44d5d876e47863ca983ba")
    }
    
    
    // 로딩중인지 확인하기 위한 함수 추가
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false
    }
    
    // 웹뷰가 성공적으로 로딩됐을 때
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!, withError error : Error) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    // 에러로 인해 로딩 실패했을 시
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error : Error) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    // 주소 받기 위한 문자열 입력 함수
    func pushURLText(_ url : String) -> String {
        var url = url
        let flag = url.hasPrefix("http://")
        if !flag {
            url = "http://" + url
        }
        return url
    }
    
    
    @IBAction func btnGoURL(_ sender: UIBarButtonItem) {
        let finURL = pushURLText(webTextField.text!)
        webTextField.text = ""
        loadWebPage(finURL)
        print("load page name ====> \(finURL)")
    }
    
    // 로딩 중지
    @IBAction func btnStop(_ sender: UIBarButtonItem) {
        myWebView.stopLoading()
    }
    
    // 재로딩
    @IBAction func btnRefresh(_ sender: UIBarButtonItem) {
        myWebView.reload()
    }
    
    // 전 페이지
    @IBAction func btnRewind(_ sender: UIBarButtonItem) {
        myWebView.goBack()
    }
    
    // 다음 페이지
    @IBAction func btnFastforward(_ sender: UIBarButtonItem) {
        myWebView.goForward()
    }
}

