//
//  TableDropDownAlbum.swift
//  SimpleApp4
//
//  Created by maedi laziman on 28/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

class TableDropDownAlbum: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var borderBottomLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
