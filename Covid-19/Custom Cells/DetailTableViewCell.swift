//
//  DetailTableViewCell.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cellBC: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
