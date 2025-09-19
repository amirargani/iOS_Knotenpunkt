//
//  ShowExcelDetailsViewController.swift
//  Knotenpunkt
//
//  Created by ARGA on 15.01.23.
//

import UIKit

class ExcelDetailsViewController: UIViewController {

    var ItemsDataTable:Items?
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sbshalomField: UITextField!
    @IBOutlet weak var moderationField: UITextField!
    @IBOutlet weak var kidsgoField: UITextField!
    //@IBOutlet weak var musikField: UITextField!
    @IBOutlet weak var gespreachsltngField: UITextField!
    @IBOutlet weak var predigtField: UITextField!
    @IBOutlet weak var kindermomentField: UITextField!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var putzdienstField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLbl.text = ItemsDataTable?.Datum
        sbshalomField.text = ItemsDataTable?.Fr_Sabbat
        moderationField.text = ItemsDataTable?.Moderation
        kidsgoField.text = ItemsDataTable?.KidsGo
        //musikField.text = ItemsDataTable?.Musik
        gespreachsltngField.text = ItemsDataTable?.Gespreachsltng
        predigtField.text = ItemsDataTable?.Predigt
        kindermomentField.text = ItemsDataTable?.Kindermoment
        timeLbl.text = ItemsDataTable?.Zeit
        locationLbl.text = ItemsDataTable?.Ort
        putzdienstField.text = ItemsDataTable?.Putzdienst
        initialSetup()
    }

    @IBAction func didTapUpdateButton(_ sender: Any) {
        let emailDetail = UserDefaults.standard.string(forKey: "email")
        let passwordDetail = UserDefaults.standard.string(forKey: "password")
        if (emailDetail != nil && passwordDetail != nil) {
            var addurl = "https://script.google.com/macros/s/AKfycbzvUp5OGpQwcwIZb8ACtVGFokLQSiTQpGl7fD471pUiWI7Lqz63kNTEkJlJdkNzEwuy/exec?action=update&"
            addurl += "Datum=" + ItemsDataTable!.Datum
            addurl += "&Fr_Sabbat=" + sbshalomField.text!
            addurl += "&Moderation=" + moderationField.text!
            addurl += "&KidsGo=" + kidsgoField.text!
            //addurl += "&Musik=" + musikField.text!
            addurl += "&Gespreachsltng=" + gespreachsltngField.text!
            addurl += "&Predigt=" + predigtField.text!
            addurl += "&Kindermoment=" + kindermomentField.text!
            addurl += "&Putzdienst=" + putzdienstField.text!
            // getLogin
            // HTTP GET Request Example in Swift
            // appsdeveloperblog.com/http-get-request-example-in-swift/
            // Swift: Saving file with special characters
            // stackoverflow.com/questions/72285893/swift-saving-file-with-special-characters
            let urlStr : String = addurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            guard let url = URL(string: urlStr.replacingOccurrences(of: " ", with: "%20")) else {
                print("Error: cannot create URL")
                return
            }

            // Create URL Request
            var request = URLRequest(url: url)

            // Specify HTTP Method to use
            request.httpMethod = "GET"

            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                // Check if Error took place
                if let error = error {
                    print("Error took place \(error)")
                    return
                }

                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }

                // Convert HTTP Response Data to a simple String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    GlobalVariables.msg = dataString
                }
            }
            task.resume()
            // getLogin
            Thread.sleep(forTimeInterval: 3.0)
            if (GlobalVariables.msg == "The update was successful.") {
                getMessage(form: "Erfolg", form: "Die Datenverarbeitung wurde erfolgreich durchgeführt.")
            }
            else {
                getMessage(form: "Fehler", form: "Beim Senden von Daten ist ein Fehler aufgetreten.")
            }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    private func initialSetup() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func hidekeyboard() {
        self.view.endEditing(true)
    }
    
//    @objc private func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            let bottomSpace = self.view.frame.height - (backButton.frame.height + backButton.frame.origin.y)
//            self.view.frame.origin.y -= keyboardHeight + bottomSpace + 10
//        }
//    }
    
//    @objc private func keyboardWillHide() {
//        self.view.frame.origin.y = 0
//    }
    
    // GlobalVariables
    struct GlobalVariables {
        static var msg = String()
    }
    
    // getMessage
    // appsdeveloperblog.com/how-to-show-an-alert-in-swift/
    private func getMessage(form title: String, form message: String) {
        // Create new Alert
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        // Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
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
        // Keyboard
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
