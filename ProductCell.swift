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


    func configureProductCell(productRange: String, baseCurr: String, destCurr:String, destCurrSymbol:String, baseCurrSymbol:String, indexPath: Int, baseCityProdList:Dictionary<String, AnyObject>, destCityProdList:Dictionary<String, AnyObject>,baseCountryFlag:String, destCountryFlag:String){
        
        currentRates.downloadExchangeRates {
            let baseProdObj = Array(baseCityProdList)[indexPath]
            let basePriceString = Float(baseProdObj.value[productRange] as! String)!
            
            let destProdObj = Array(destCityProdList)[indexPath]
            let destPriceString = Float(destProdObj.value[productRange] as! String)!
            
            if baseProdObj.key == destProdObj.key {
                
//                self.productNameLbl.text = baseProdObj.key
                self.baseCountryIcon.image = UIImage(named: baseCountryFlag)
                self.destCountryIcon.image = UIImage(named: destCountryFlag)
                
                switch (baseProdObj.key)
                {
                case "ImpBeer":
                    self.productNameLbl.text = "Imported Beer"
                    self.productIcon.image = UIImage(named:"ImpBeer")
                    
                case "DomBeer":
                    self.productNameLbl.text = "Domestic Beer"
                    self.productIcon.image = UIImage(named:"DomBeer")
                    
                case "WineBottle":
                    self.productNameLbl.text = "Wine Bottle"
                    self.productIcon.image = UIImage(named:"WineBottle")
                    
                case "Coke":
                    self.productNameLbl.text = "Can (340ml)"
                    self.productIcon.image = UIImage(named:"Coke")
                    
                case "MovieTicket":
                    self.productNameLbl.text = "Movie Ticket"
                    self.productIcon.image = UIImage(named:"MovieTicket")
                    
                case "PackSmokes":
                    self.productNameLbl.text = "Cigarettes (20)"
                    self.productIcon.image = UIImage(named:"PackSmokes")
                    
                case "McMeal":
                    self.productNameLbl.text = "Big Mac"
                    self.productIcon.image = UIImage(named:"McMeal")
                    
                case "WaterBottle":
                    self.productNameLbl.text = "Water Bottle"
                    self.productIcon.image = UIImage(named:"WaterBottle")
                    
                case "Meal":
                    self.productNameLbl.text = "Meal"
                    self.productIcon.image = UIImage(named:"Meal")
                    
                case "OneWayTicket":
                    self.productNameLbl.text = "Travel Ticket"
                    self.productIcon.image = UIImage(named:"OneWayTicket")
                    
                default:
                    break
                }
                
                
                self.baseProdPrice.text = "\(baseCurrSymbol)\(String(format: "%.2f", basePriceString))"
                self.destProdPrice.text = "\(destCurrSymbol)\(String(format: "%.2f", destPriceString))"
                
                let convertedPrice = Float(self.currentRates.doConvertion(dest: baseCurr, base: destCurr, price: destPriceString))!
                
                let calc = basePriceString - convertedPrice
                
                self.calculationLbl.text = "\(baseCurrSymbol)\(String(format: "%.2f", abs(calc)))"
                let basePriceText = basePriceString
                let difPrice = Float(abs(calc))
                
                
                if difPrice >= basePriceText {
                    self.expensiveLbl.text = "More Expensive"
                    self.expensiveIcon.image = UIImage(named:"moreExpensive_arrow")
                } else {
                    self.expensiveLbl.text = "Less Expensive"
                    self.expensiveIcon.image = UIImage(named:"lessExpensive_arrow")
                }
            }
            
        }
        
        
    }

}
