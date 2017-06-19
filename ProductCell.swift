//
//  ProductCell.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/09.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    var currentRates: CurrentExchange!
    
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
        currentRates = CurrentExchange()
    }


    func configureProductCell(productRange: String, baseCurr: String, destCurr:String, destCurrSymbol:String, baseCurrSymbol:String, indexPath: Int, baseCityProdList:Dictionary<String, AnyObject>, destCityProdList:Dictionary<String, AnyObject>){
        
        currentRates.downloadExchangeRates {
            let baseProdObj = Array(baseCityProdList)[indexPath]
            let basePriceString = Float(baseProdObj.value[productRange] as! String)!
            
            let destProdObj = Array(destCityProdList)[indexPath]
            let destPriceString = Float(destProdObj.value[productRange] as! String)!
            
            if baseProdObj.key == destProdObj.key {
                
                self.productNameLbl.text = baseProdObj.key
                
                self.baseProdPrice.text = "\(baseCurrSymbol)\(basePriceString)"
                self.destProdPrice.text = "\(destCurrSymbol)\(destPriceString)"
                
                let convertedPrice = Float(self.currentRates.doConvertion(dest: baseCurr, base: destCurr, price: destPriceString))!
                
                let calc = basePriceString - convertedPrice
                
                self.calculationLbl.text = "\(baseCurrSymbol)\(String(format: "%.2f", abs(calc)))"
                let basePriceText = basePriceString
                let difPrice = Float(abs(calc))
                
                
                if difPrice >= basePriceText {
                    self.expensiveLbl.text = "More Expensive"
                } else {
                    self.expensiveLbl.text = "Less Expensive"
                }
            }
            
        }
        
        
    }

}
