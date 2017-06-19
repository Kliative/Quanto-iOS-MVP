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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCityCell(cityName:String){
        self.cityLbl.text = cityName
    }

}
