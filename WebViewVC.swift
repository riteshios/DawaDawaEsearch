//  WebViewVC.swift
//  Dawadawa
//  Created by Ritesh Gupta on 04/07/22.

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    @IBOutlet weak var lblheading: UILabel!
    @IBOutlet weak var webkit: WKWebView!
    var strurl = ""
    var head = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("strurl=",strurl)
        debugPrint("head=",head)
        
        guard let url = URL(string: strurl) else{
            return
        }
        
        webkit.load(URLRequest(url:url))
        self.lblheading.text = self.head
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
