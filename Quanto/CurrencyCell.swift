//
//  CurrencyCell.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/19.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCurrencyCell(countryName:String, countryCode:String, currencyName:String){
        self.countryNameLbl.text = countryName
        self.currencyImage.image = UIImage(named: countryCode)
        self.currencyNameLbl.text = currencyName
    }

}
