//
//  RoomTableViewCell.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/13/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomPhotoImageView: UIImageView!
    @IBOutlet weak var currentNumberLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
