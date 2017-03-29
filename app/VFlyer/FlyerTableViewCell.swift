//
//  FlyerTableViewCell.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

class FlyerTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
