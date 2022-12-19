//  DocumentWebView.swift
//  Dawadawa
//  Created by Ritesh Gupta on 19/12/22.

import UIKit
import WebKit


class DocumentWebView: UIViewController {
    
    @IBOutlet weak var lblheading: UILabel!
    @IBOutlet weak var webkit: WKWebView!
    var docurl  = "https://demo4esl.com/dawadawa/public/front_assets/assets/media/opportunity_documents/EJAZ%20AHMED.pdf"
    var heading = ""
    
// MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblheading.text = self.heading
        webkit.load(URLRequest(url: URL(string: docurl)!))
       
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
