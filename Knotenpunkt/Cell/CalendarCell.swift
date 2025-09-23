//
//  CalendarCellCell.swift
//  Knotenpunkt
//
//  Created by ARGA on 25.12.22.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var table: UIView!
    @IBOutlet weak var DatumLbl: UILabel!
    @IBOutlet weak var ZeitLbl: UILabel!
    @IBOutlet weak var TitelLbl: UILabel!
    @IBOutlet weak var BeschreibungLbl: UILabel!
    @IBOutlet weak var OrtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
