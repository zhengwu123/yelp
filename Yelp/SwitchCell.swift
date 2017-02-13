//
//  SwitchCell.swift
//  Yelp
//
//  Created by zheng wu on 1/30/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol SwitchCellDelegate{
    @objc optional func switchCell(switchcell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet var switchButton: UISwitch!
    @IBOutlet var switchlabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        print("chao!")
        delegate?.switchCell?(switchcell: self, didChangeValue: switchButton.isOn)
    }
}
