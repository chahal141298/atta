//
//  DeviceHomeCell.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit

class DeviceHomeCell: UICollectionViewCell {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var deviceIdLabel: UILabel!
    ///
    @IBOutlet weak var addressLabel: UILabel!
    
    ///
     var delegate: DeviceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
