//
//  ExcelViewController.swift
//  Knotenpunkt
//
//  Created by ARGA on 12.11.22.
//

import UIKit


class ExcelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    let getDataTable = GetDataTableGodiplan()
    var ItemsDataTable = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataTable.getData {
            data in
            self.ItemsDataTable = data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        table.delegate = self
        table.dataSource = self
        table.separatorColor = .clear
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true) // 300seconds -> 5minutes
        
    }
    
    @objc func refreshData() -> Void
    {
        getDataTable.getData {
            data in
            self.ItemsDataTable = data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsDataTable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "GodiplanCell", for: indexPath)
        as! GodiplanCell
        if ItemsDataTable[indexPath.row].Datum == self.formatDate(date: Date()) {
            cell.DatumLbl?.text = ItemsDataTable[indexPath.row].Datum
            cell.DatumLbl.textColor = .white
            cell.DatumLbl.font = .boldSystemFont(ofSize: 17)
            //j-william.com/en/%E3%80%90swift%E3%80%91how-to-change-the-color-of-text/
            let knotiColorRed = UIColor(red: 0.555, green: 0.105, blue: 0.143, alpha: 1.0)
            cell.DatumLbl.backgroundColor = knotiColorRed
        } else {
            cell.DatumLbl?.text = ItemsDataTable[indexPath.row].Datum
            cell.DatumLbl.textColor = .white
            cell.DatumLbl.font = .boldSystemFont(ofSize: 17)
            let knotiColorGray = UIColor(red: 0.381, green: 0.385, blue: 0.391, alpha: 1.0)
            cell.DatumLbl.backgroundColor = knotiColorGray
            // else
            //cell.DatumLbl.textColor = .black
            //cell.DatumLbl.font = .systemFont(ofSize: 17)
            //cell.DatumLbl.backgroundColor = .clear
        }
        if ItemsDataTable[indexPath.row].Fr_Sabbat != "" {
            cell.SabbatSchalomLbl?.text = ItemsDataTable[indexPath.row].Fr_Sabbat
        } else {
            cell.SabbatSchalomLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Moderation != "" {
            cell.ModerationLbl?.text = ItemsDataTable[indexPath.row].Moderation
        } else {
            cell.ModerationLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].KidsGo != "" {
            cell.KidsGoLbl?.text = ItemsDataTable[indexPath.row].KidsGo
        } else {
            cell.KidsGoLbl?.text = "-"
        }
//        if ItemsDataTable[indexPath.row].Musik != "" {
//            cell.MusikLbl?.text = ItemsDataTable[indexPath.row].Musik
//        } else {
//            cell.MusikLbl?.text = "-"
//        }
        if ItemsDataTable[indexPath.row].Gespreachsltng != "" {
            cell.GespreachltngLbl?.text = ItemsDataTable[indexPath.row].Gespreachsltng
        } else {
            cell.GespreachltngLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Predigt != "" {
            if ItemsDataTable[indexPath.row].Predigt.count < 20 {
                cell.PredigtLbl?.text = ItemsDataTable[indexPath.row].Predigt
                cell.PredigtLbl.font = .systemFont(ofSize: 17)
            }
            else {
                cell.PredigtLbl?.text = ItemsDataTable[indexPath.row].Predigt
                cell.PredigtLbl.font = .systemFont(ofSize: 13)
            }
                
        } else {
            cell.PredigtLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Kindermoment != "" {
            cell.KindermomentLbl?.text = ItemsDataTable[indexPath.row].Kindermoment
        } else {
            cell.KindermomentLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Zeit != "" {
            cell.ZeitLbl?.text = ItemsDataTable[indexPath.row].Zeit
        } else {
            cell.ZeitLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Ort != "" {
            cell.OrtLbl?.text = ItemsDataTable[indexPath.row].Ort
        } else {
            cell.OrtLbl?.text = "-"
        }
        if ItemsDataTable[indexPath.row].Putzdienst != "" {
            cell.PutzdienstLbl?.text = ItemsDataTable[indexPath.row].Putzdienst
        } else {
            cell.PutzdienstLbl?.text = "-"
        }
        // Disable Selection
        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        // Hide Separator or Change Left Side Spacing
        //cell.separatorInset = .zero
        //cell.layoutMargins = .zero
//        if (indexPath.row % 2) == 0 {
//            cell.separatorInset.left = 100
//        }
        return cell
    }
    
    // stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
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
