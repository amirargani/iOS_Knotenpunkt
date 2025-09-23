//
//  LoginController.swift
//  Knotenpunkt
//
//  Created by ARGA on 08.01.23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Save Mail and Password -- autoLogin
        let emailDetail = UserDefaults.standard.string(forKey: "email")
        let passwordDetail = UserDefaults.standard.string(forKey: "password")
        if (emailDetail != nil && passwordDetail != nil) {
            emailField.text = emailDetail
            passwordField.text = passwordDetail
        }
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        if (emailField.text == "") {
            getMessage(form: "Fehler", form: "Gib deine E-Mail-Adresse ein.")
        }
        if (passwordField.text == "") {
            getMessage(form: "Fehler", form: "Gib dein Passwort ein.")
        }
        if (emailField.text != "" && passwordField.text != "") {
            guard
                let email = emailField.text,
                let password = passwordField.text
                else { return }
            let isValidEmailAddress = isValidEmailAddress(emailAddressString: email)
            if (isValidEmailAddress) {
                let url = "https://script.google.com/macros/s/AKfycbw9O-c05FMgYDmEbkBQwrc4gFABN_9qrbia-Imp8FOOlqHUNrRXKTuzFLpydsfZlauJYA/exec?&action=login&"
                let addurl = url + "email=" + email + "&password=" + password
                GlobalVariables.email = email
                GlobalVariables.password = password
                // getLogin
                let task =  URLSession.shared.dataTask(with: URL(string: addurl)!, completionHandler: {data, response, error in
                    guard let data = data, error == nil else {
                        print("Data received successfully.")
                        return
                    }
                    // have data
                    var result: ResponseUser?
                    do {
                        result = try JSONDecoder().decode(ResponseUser.self, from: data)
                    }
                    catch {
                        print("An error occurred while receiving data.")
                        GlobalVariables.email = ""
                        GlobalVariables.password = ""
                    }
                    guard let json = result else {
                        return
                    }
                    for i in json.itemsUser {
                        GlobalVariables.email = i.Email
                        GlobalVariables.password = i.Password
                        print(i.Email)
                    }
                    // ackingwithswift.com/sixty/4/1/for-loops
                    // geeksforgeeks.org/how-to-count-the-elements-of-an-array-in-swift/
                })
                    task.resume()
                // getLogin
                Thread.sleep(forTimeInterval: 5.0)
                if (GlobalVariables.email == email && GlobalVariables.password == password) {
                    UserDefaults.standard.set(GlobalVariables.email, forKey: "email")
                    UserDefaults.standard.set(GlobalVariables.password, forKey: "password")
                    //self.performSegue(withIdentifier: "godidetailsSegue", sender: self)
                    dismiss(animated: true, completion: nil)
                }
                else {
                    getMessage(form: "Fehler", form: "Deine Zugangsdaten sind leider unvollständig oder fehlerhaft, bitte überprüfe deine Angaben.")
                }
            }
            else {
                getMessage(form: "Fehler", form: "Deine E-Mail-Adresse ist ungültig.")
            }
        }
    }
    
    @IBAction func didTapbackButton(_ sender: Any) {
//        guard let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "tabbarvc") as? UITabBarController else {
//            return
//        }
//        tabbarVC.modalPresentationStyle = .fullScreen
//        tabbarVC.modalTransitionStyle = .crossDissolve
//        present(tabbarVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // GlobalVariables
    struct GlobalVariables {
        static var email = String()
        static var password = String()
    }
    
    // app.quicktype.io -> Convert json to swift <-
    // MARK: - ResponseUser
    struct ResponseUser: Codable {
        let itemsUser: [ItemsUser]
    }

    // MARK: - ItemsUser
    struct ItemsUser: Codable {
        let Email, Password: String
    }
    
    // isValidEmailAddress
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
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
    }
}
