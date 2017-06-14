//
//  ProductCell.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/09.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var baseCountryIcon: UIImageView!
    @IBOutlet weak var baseProdPrice: UILabel!
    @IBOutlet weak var destCountryIcon: UIImageView!
    @IBOutlet weak var destProdPrice: UILabel!
    @IBOutlet weak var expensiveLbl: UILabel!
    @IBOutlet weak var expensiveIcon: UIImageView!
    @IBOutlet weak var calculationLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
