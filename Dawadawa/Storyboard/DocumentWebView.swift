//  DocumentWebView.swift
//  Dawadawa
//  Created by Ritesh Gupta on 19/12/22.

import UIKit
import WebKit


class DocumentWebView: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var lblheading: UILabel!
    @IBOutlet weak var webkit: WKWebView!
    var opr_doc  = "https://demo4app.com/dawadawa/public/front_assets/assets/media/opportunity_documents/"
    var doclink  = ""
    var heading  = "Document"
    
// MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webkit.navigationDelegate = self
        self.doc()
    }
    
    func doc(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let docurl   = "\(self.opr_doc)\(self.doclink)"
        print("\(docurl)dockurlcheck=-=-=-")
        self.lblheading.text = self.heading
//        webkit.load(URLRequest(url: URL(string: docurl)!))
        
        if let encodedDocurl = docurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedDocurl) {
            webkit.load(URLRequest(url: url))
        } else {
            print("Invalid URL string: \(docurl)")
        }


    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CommonUtils.showHudWithNoInteraction(show: false)
        print("Loder Stop")
        // or what you want
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
