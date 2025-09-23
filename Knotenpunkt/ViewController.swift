//
//  ViewController.swift
//  Knotenpunkt
//
//  Created by ARGA on 26.10.22.
//

import UIKit
import WebKit

let reachability = try! Reachability()

class ViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    //stackoverflow.com/questions/35280747/hide-statusbar-during-splash-screen
    //eveloper.appl.com/documentation/uikit/uiviewcontroller/1621440-prefersstatusbarhidden
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
//    override func loadView() {
//        //let webConfiguration = WKWebViewConfiguration()
//        //webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        //webView.uiDelegate = self
//        //view = webView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Thread.sleep(forTimeInterval: 5.0)
        let myURL = URL(string:"https://app.knotenpunkt.info/appnews")
        //let myURL = URL(string:"https://apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via wifi")
                }else{
                    print("Reachable via cellular")
                }
                self.view.window?.rootViewController?.dismiss(animated: true)
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
                if let networkVC = self.storyboard?.instantiateViewController(identifier: "NetworkErrorViewController") as? NetworkErrorViewController{
                    self.present(networkVC, animated: true)
                }
            }
            do{
                try reachability.startNotifier()
            }catch{
                print("unable to start notifier")
            }
        }
    }
    deinit {
        reachability.stopNotifier()
    }
}
