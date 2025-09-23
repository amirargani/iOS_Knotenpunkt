//
//  ExcelDetailsViewController.swift
//  Knotenpunkt
//
//  Created by ARGA on 09.01.23.
//

import UIKit

class ExcelTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let getDataTable = GetDataTableGodiplan()
    var ItemsDataTable = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true) // 1seconds
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func refreshData() -> Void
    {
        getDataTable.getData {
            data in
            self.ItemsDataTable = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsDataTable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = ItemsDataTable[indexPath.row].Datum
        // Color Selection
        cell.selectionStyle = .none
        // Change Left Side Spacing
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ExcelDetailsViewController {
            destination.ItemsDataTable = self.ItemsDataTable[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    private func autoLogin() {
        
        // Save Mail and Password -- autoLogin
        let emailDetail = UserDefaults.standard.string(forKey: "email")
        let passwordDetail = UserDefaults.standard.string(forKey: "password")
        if (emailDetail == nil && passwordDetail == nil) {
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginvc") as? LoginViewController else {
                return
            }
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            present(loginVC, animated: true, completion: nil)
        }
        else {
            refreshData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoLogin()
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
