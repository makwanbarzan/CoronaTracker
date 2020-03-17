//
//  HomeTableViewCell.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var caseNums: UILabel!
    @IBOutlet weak var deathNums: UILabel!
    @IBOutlet weak var recoveryNums: UILabel!
    
    @IBOutlet weak var caseLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var recoverLabel: UILabel!
    
    
    @IBOutlet weak var countryImage: UIImageView!
    
    @IBOutlet weak var recoveryBC: UIView!
    @IBOutlet weak var deathBC: UIView!
    @IBOutlet weak var caseBC: UIView!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
