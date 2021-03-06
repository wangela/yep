//
//  SwitchCell.swift
//  Yep
//
//  Created by Angela Yu on 9/19/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCellToggled(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
//    var filterIdentifier: FilterIdentifier! {
//        didSet {
//            switchLabel?.text = filterIdentifier?.rawValue
//        }
//    }

    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
            delegate?.switchCellToggled?(switchCell: self, didChangeValue: onSwitch.isOn)
    }

}
