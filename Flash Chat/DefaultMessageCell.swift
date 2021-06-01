//
//  DefaultMessageCell.swift
//  Flash Chat
//
//  Created by Jervy Umandap on 6/1/21.
//  Copyright © 2021 London App Brewery. All rights reserved.
//

import UIKit

class DefaultMessageCell: UITableViewCell {
    
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        avatarImageView.layer.cornerRadius = 5.0
        
        
        
    }
    
}
