//
//  CustomCell.swift
//  Knotenpunkt
//
//  Created by ARGA on 23.12.22.
//

import UIKit

class GodiplanCell: UITableViewCell {
    
    
    @IBOutlet weak var table: UIView!
    
    @IBOutlet weak var DatumLbl: UILabel!
    @IBOutlet weak var SabbatSchalomLbl: UILabel!
    @IBOutlet weak var ModerationLbl: UILabel!
    @IBOutlet weak var KidsGoLbl: UILabel!
    //@IBOutlet weak var MusikLbl: UILabel!
    @IBOutlet weak var GespreachltngLbl: UILabel!
    @IBOutlet weak var PredigtLbl: UILabel!
    @IBOutlet weak var KindermomentLbl: UILabel!
    @IBOutlet weak var ZeitLbl: UILabel!
    @IBOutlet weak var OrtLbl: UILabel!
    @IBOutlet weak var PutzdienstLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
