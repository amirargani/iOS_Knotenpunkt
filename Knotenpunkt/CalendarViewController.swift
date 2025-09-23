//
//  CalendarViewController.swift
//  Knotenpunkt
//
//  Created by ARGA on 12.11.22.
//

import UIKit
import WebKit

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let getDataTable = GetDataTableCalendar()
    var ItemsDataTable = [ItemsCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataTable.getDataCalender {
            data in
            self.ItemsDataTable = data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        table.delegate = self
        table.dataSource = self
        table.separatorColor = .clear
        _ = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true) // 300seconds -> 5minutes
        
    }
    
    @objc func refreshData() -> Void
    {
        getDataTable.getDataCalender {
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
        let cell = table.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
        as! CalendarCell
        if ItemsDataTable[indexPath.row].Startdatum == self.formatDate(date: Date()) {
            cell.DatumLbl?.text = ItemsDataTable[indexPath.row].Startdatum
            cell.DatumLbl.textColor = .white
            cell.DatumLbl.font = .boldSystemFont(ofSize: 17)
            //j-william.com/en/%E3%80%90swift%E3%80%91how-to-change-the-color-of-text/
            let knotiColorBlue = UIColor(red: 0.000, green: 0.273, blue: 0.770, alpha: 1.0)
            cell.DatumLbl.backgroundColor = knotiColorBlue
        } else {
            cell.DatumLbl?.text = ItemsDataTable[indexPath.row].Startdatum
            cell.DatumLbl.textColor = .white
            cell.DatumLbl.font = .boldSystemFont(ofSize: 17)
            let knotiColorGray = UIColor(red: 0.381, green: 0.385, blue: 0.391, alpha: 1.0)
            cell.DatumLbl.backgroundColor = knotiColorGray
        }
        if ItemsDataTable[indexPath.row].Startzeit != "" {
            cell.ZeitLbl?.text = ItemsDataTable[indexPath.row].Startzeit
            + " - " + ItemsDataTable[indexPath.row].Endzeit
            cell.ZeitLbl.textColor = .black
            cell.ZeitLbl.font = .boldSystemFont(ofSize: 17)
            let knotiColorYellow = UIColor(red: 1.000, green: 0.877, blue: 0.000, alpha: 1.0)
            cell.ZeitLbl.backgroundColor = knotiColorYellow
        }
        if ItemsDataTable[indexPath.row].Titel != "" {
            cell.TitelLbl?.text = ItemsDataTable[indexPath.row].Titel
            cell.TitelLbl.font = .boldSystemFont(ofSize: 12)
        } else {
            cell.TitelLbl?.text = ""
        }
        if ItemsDataTable[indexPath.row].Beschreibung != "" {
            cell.BeschreibungLbl?.text = ItemsDataTable[indexPath.row].Beschreibung
            cell.BeschreibungLbl.font = .systemFont(ofSize: 12)
        } else {
            cell.BeschreibungLbl?.text = ""
        }
        if ItemsDataTable[indexPath.row].Ort != "" {
            cell.OrtLbl?.text = ItemsDataTable[indexPath.row].Ort
            cell.OrtLbl.font = .systemFont(ofSize: 12)
        } else {
            cell.OrtLbl?.text = ""
        }
        // Disable Selection
        cell.isUserInteractionEnabled = false
        cell.selectionStyle = .none
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
