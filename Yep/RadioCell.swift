//
//  RadioCell.swift
//  Yep
//
//  Created by Angela Yu on 9/22/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import AIFlatSwitch

@objc protocol RadioCellDelegate {
    @objc optional func radioCellTapped(radioCell: RadioCell)
}

class RadioCell: UITableViewCell {
    
    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var radioSwitch: AIFlatSwitch!
    
    weak var delegate: RadioCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchTapped() {
        delegate?.radioCellTapped?(radioCell: self)
    }
    
}
