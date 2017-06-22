//
//  CityCell.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/14.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCityCell(cityName:String){
        self.cityLbl.text = cityName
        
    }

}
