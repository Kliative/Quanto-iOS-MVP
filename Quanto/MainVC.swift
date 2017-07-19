//
//  ViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource,baseDataSentDelegate, destDataSentDelegate {
    
    var destCityData = [CityData]()
    var baseCityData = [CityData]()
    var baseCapitalData = [CityData]()
    
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var compareBtnProdHead: UIButton!
    
    var productList:Int!
    var destProdListDict: Dictionary<String, AnyObject>!
    var baseProdListDict: Dictionary<String, AnyObject>!
    
    var capitalName:String!
    var baseCitySel:String!
    var destCitySel:String!
    
    var isBaseFull = false
    var isDestFull = false
    
    var baseCities:[String] = []
    var destCities:[String] = []
    
    var baseBtnTime:Timer!
    var destBtnTime:Timer!
    
    @IBOutlet weak var cokeDestLbl: CountingLabel!
    @IBOutlet weak var domBeerDestLbl: CountingLabel!
    @IBOutlet weak var mealDestLbl: CountingLabel!
    @IBOutlet weak var oneWayTicketLbl: CountingLabel!
    @IBOutlet weak var mcmealDestLbl: CountingLabel!

    @IBOutlet weak var swipeInstructLbl: UILabel!
    
    @IBOutlet weak var baseCountryLbl: UILabel!
    @IBOutlet weak var destCountryLbl: UILabel!
    
    @IBOutlet weak var ProdStackPromptLbl: UILabel!
    @IBOutlet weak var prodHeadProdLbl: UILabel!
    @IBOutlet weak var prodHeadArbLbl: UILabel!
    
    var baseCountryFlagName:String!
    var destCountryFlagName:String!
    
    @IBOutlet weak var calculationLbl: UILabel!
    @IBOutlet weak var baseCurrencyLbl: UILabel!
    @IBOutlet weak var destinationCurrencyLbl: UILabel!

    @IBOutlet weak var baseCountryBtn: UIButton!
    @IBOutlet weak var destCountryBtn: UIButton!

    @IBOutlet weak var productListTableView:UITableView!
    @IBOutlet weak var baseCityTableView:UITableView!
    @IBOutlet weak var destCityTableView:UITableView!
    
    @IBOutlet weak var calculaterView: UIView!
    
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var dcView: UIView!
    @IBOutlet weak var destCityBtn: UIButton!
    @IBOutlet weak var baseCityBtn: UIButton!
    
    
    @IBOutlet weak var divideBtn: UIButton!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var decimalBtn: UIButton!
    
    var onceOff:Int!
    var onceOffTap:Bool!
    
    var onceOffTapInstruction:Bool!
    
    @IBOutlet weak var destCountrySelSV: UIStackView!
    @IBOutlet weak var baseCountrySelSV: UIStackView!
    
    @IBOutlet weak var cityVsCityStackV: UIStackView!
    @IBOutlet weak var citiesTvStackV: UIStackView!
    
    @IBOutlet weak var prodStackV: UIStackView!
    @IBOutlet weak var prodImagBG: UIImageView!
    
    @IBOutlet weak var survivingBtn: UIButton!
    @IBOutlet weak var chillinBtn: UIButton!
    @IBOutlet weak var ballinBtn: UIButton!
    
    var destCapital:String!
    var productRangeSel: String!
    
    var cityIndexRow: Int!
    
    var baseCurrSymbol: String!
    var destCurrSymbol: String!
    
    var destCountryKey:String!
    var baseCountryKey:String!
    
    var currentRates: CurrentExchange!
    
    var displayRunningNumber = ""
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = "0"
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    
    var buttonsEnabled: Bool!
    var decimalEnabled: Bool!
    
    var baseCurrSel: String!
    var destCurrSel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.productListTableView.delegate = self
        self.productListTableView.dataSource = self
        
        self.baseCityTableView.delegate = self
        self.baseCityTableView.dataSource = self
        
        self.destCityTableView.delegate = self
        self.destCityTableView.dataSource = self
        
        self.cityVsCityStackV.isHidden = true
        self.citiesTvStackV.isHidden = true
        self.prodStackV.isHidden = true
        self.ProdStackPromptLbl.alpha = 0
        self.destCountryBtn.contentHorizontalAlignment = .left
        self.calculaterView.isHidden = true
        
        currentRates = CurrentExchange()
        currentRates.downloadExchangeRates {}
        
        self.decimalEnabled = true
        decimalBtn.isUserInteractionEnabled = true
        
        calculationLbl.text = "Swipe right to reset numbers"
        self.swipeInstructLbl.alpha = 0
        baseCurrencyLbl.text = "Tap for Pad"
        destinationCurrencyLbl.text = "0"
        onceOffTap = false
        onceOffTapInstruction = true
        
        self.cokeDestLbl.text = ""
        self.domBeerDestLbl.text = ""
        self.oneWayTicketLbl.text = ""
        self.mealDestLbl.text = ""
        self.mcmealDestLbl.text = ""
        
        self.productRangeSel = "norm"
        
        self.destProdListDict = [:]
        self.baseProdListDict = [:]
        
        
        self.calculationLbl.alpha = 0
        self.baseCurrencyLbl.alpha = 0
        self.destinationCurrencyLbl.alpha = 0
        self.compareBtnProdHead.alpha = 0
        self.prodHeadProdLbl.alpha = 0
        self.prodHeadArbLbl.alpha = 0
        self.disableBtns()
        
        if self.destCurrSel == nil || self.baseCurrSel == nil {
            self.destCurrSel = "ZAR"
            self.baseCurrSel = "ZAR"
            self.baseCountryLbl.text = "Start Here"
            self.destCountryLbl.text = ""
            self.destCountryBtn.alpha = 0
        }
        
        self.baseBtnTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainVC.addBasePulse), userInfo: nil, repeats: true)
        
        self.onceOff = 0
    }
    
    func userDidEnterDestData(data: CountryData) {
        self.destBtnTime.invalidate()
        self.isDestFull = false
        self.resetAll()
        self.destCountryKey = data.countryName
        self.destCountryBtn.setBackgroundImage(UIImage(named: data.countryCode), for: .normal)
        self.destCurrSel = data.currencyCode
        self.destCurrSymbol = data.currencySymbol
        self.destCities = data.cities
        self.destCapital = data.capitalName
        self.getDestCitiesProd(countryKey: data.countryName
            , cityKey: data.capitalName, productRange: self.productRangeSel)
        self.destCountryLbl.text = data.currencyCode
        self.destCountryFlagName = data.countryCode
        self.globalProdAmount()
        
//        print("---- destFull Negative \(self.isDestFull)")
        
        
        
        UIView.animate(withDuration: 0.5) {
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width/2
            self.bcView.center.x = (self.view.frame.width - self.view.frame.width) + self.bcView.frame.width/2
            self.baseCityBtn.setTitle("▾ Select City", for: .normal)
            self.destCityBtn.setTitle("▾ Select City", for: .normal)
            self.destCountryBtn.alpha = 1
            
        }
        if self.baseCities.count > 0 && self.destCities.count > 0 {
            self.cityVsCityStackV.isHidden = false
            self.citiesTvStackV.isHidden = false
//            self.prodStackV.isHidden = false
            
            self.prodImagBG.backgroundColor = UIColor(red:192/255,green:57/255,blue:43/255,alpha:1.0)
            self.captionLbl.text = "Now select cities"
        }
        self.onceOff = 1
        self.destCityTableView.reloadData()
        
        
    }
    
    func userDidEnterBaseData(data: CountryData) {
        //Animation
        self.baseBtnTime.invalidate()
        self.isBaseFull = false
        self.resetAll()
        self.baseCountryKey = data.countryName
        self.baseCountryBtn.setBackgroundImage(UIImage(named: data.countryCode), for: .normal)
        self.baseCurrSel = data.currencyCode
        self.baseCities = data.cities
        self.baseCurrSymbol = data.currencySymbol
        self.getBaseCitiesProd(countryKey: data.countryName
            , cityKey: data.capitalName, productRange: self.productRangeSel)
        self.baseCountryLbl.text = data.currencyCode
        self.baseCountryFlagName = data.countryCode
        
//        print("---- baseFull Negative \(self.isBaseFull)")
        
        if onceOffTapInstruction == false {
            baseCurrencyLbl.text = "0"
        }
        
        UIView.animate(withDuration: 0.5) {
            self.bcView.center.x = (self.view.frame.width - self.view.frame.width) + self.bcView.frame.width/2
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width/2
            self.baseCityBtn.setTitle("▾ Select City", for: .normal)
            self.destCityBtn.setTitle("▾ Select City", for: .normal)
            self.destCountryBtn.alpha = 1
            
        }
        if self.baseCities.count > 0 && self.destCities.count > 0 {
            self.cityVsCityStackV.isHidden = false
            self.citiesTvStackV.isHidden = false
//            self.prodStackV.isHidden = false
            
            self.prodImagBG.backgroundColor = UIColor(red:192/255,green:57/255,blue:43/255,alpha:1.0)
            self.captionLbl.text = "Now Select the Cities"
        }
        
        self.baseCityTableView.reloadData()
        
        if onceOffTapInstruction == false {
            baseCurrencyLbl.text = "0"
        }
        
        if onceOff == 0 {
            self.destBtnTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainVC.addDestPulse), userInfo: nil, repeats: true)
            self.destCountryLbl.text = "Destination"
            self.onceOff = 1
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch tableView {
        case productListTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for:indexPath) as? ProductCell{
                cell.configureProductCell(productRange:self.productRangeSel, baseCurr:self.baseCurrSel, destCurr: self.destCurrSel, destCurrSymbol: self.destCurrSymbol, baseCurrSymbol: self.baseCurrSymbol, indexPath: indexPath.row, baseCityProdList: self.baseProdListDict, destCityProdList: self.destProdListDict, baseCountryFlag: self.baseCountryFlagName, destCountryFlag: self.destCountryFlagName)
                
                return cell
            } else {
                return ProductCell()
            }
        case baseCityTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCityCell", for:indexPath) as? CityCell{
                cell.configureCityCell(cityName: self.baseCities[indexPath.row])
                if(cell.isSelected){
                    cell.backgroundColor = UIColor.red
                }else{
                    cell.backgroundColor = UIColor.clear
                }
                return cell
                
            } else {
                return CityCell()
            }
        case destCityTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DestCityCell", for:indexPath) as? CityCell{
                cell.configureCityCell(cityName: self.destCities[indexPath.row])
                if(cell.isSelected){
                    cell.backgroundColor = UIColor.red
                }else{
                    cell.backgroundColor = UIColor.clear
                }
                return cell
                
            } else {
                return CityCell()
            }
        default:
            return UITableViewCell()
        }
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch tableView
        {
            case productListTableView:
                if self.baseProdListDict.count == self.destProdListDict.count {
                    return self.baseProdListDict.count
                } else {
                    return 0
                }
                
            case baseCityTableView:
                return self.baseCities.count
                
            case destCityTableView:
                 return self.destCities.count
                
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:74/255, green:74/255, blue:74/255,alpha:1)
        
        self.cityIndexRow = indexPath.row
        
        switch tableView
        {
        case productListTableView:
                print("1")
            
        case baseCityTableView:
            self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
            
            
            FIRAnalytics.logEvent(withName: "Base_City_Sel", parameters: ["City":self.baseCities[self.cityIndexRow]])
            self.baseCityBtn.setTitle(self.baseCities[self.cityIndexRow], for: .normal)
            self.baseCitySel = "\(self.baseCities[self.cityIndexRow])"
            self.isBaseFull = true
            self.baseCityBtn.backgroundColor = UIColor(red:65/255, green:18/255, blue:13/255, alpha:1)
            
            if self.isDestFull && self.isBaseFull {
                
                self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
                self.globalProdAmount()
                self.animateTable()
                UIView.animate(withDuration: 0.5) {
                    self.dcView.center.x = self.view.frame.width + self.dcView.frame.width
                    self.bcView.center.x = (self.view.frame.width - self.view.frame.width) - self.bcView.frame.width
                    self.calculationLbl.alpha = 1
                    self.baseCurrencyLbl.alpha = 1
                    self.destinationCurrencyLbl.alpha = 1
                    self.compareBtnProdHead.alpha = 1
                    self.prodHeadProdLbl.alpha = 1
                    self.prodHeadArbLbl.alpha = 1
                    self.prodStackV.isHidden = true
                    self.ProdStackPromptLbl.alpha = 1
                    
                }
                self.isBaseFull = false
                self.resetAll()
                if onceOffTapInstruction == false {
                    baseCurrencyLbl.text = "0"
                }
            }
            
        case destCityTableView:
            self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
            FIRAnalytics.logEvent(withName: "Dest_City_Sel", parameters: ["City":self.destCities[self.cityIndexRow]])
            self.destCityBtn.setTitle(self.destCities[self.cityIndexRow], for: .normal)
            self.destCitySel = "\(self.destCities[self.cityIndexRow])"
            self.isDestFull = true
            self.destCityBtn.backgroundColor = UIColor(red:65/255, green:18/255, blue:13/255, alpha:1)
            
            
            if self.isDestFull && self.isBaseFull {
                
                
                
                self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
                self.globalProdAmount()
                self.animateTable()
                UIView.animate(withDuration: 0.5) {
                    self.dcView.center.x = self.view.frame.width + self.dcView.frame.width
                    self.bcView.center.x = (self.view.frame.width - self.view.frame.width) - self.bcView.frame.width
                    self.calculationLbl.alpha = 1
                    self.baseCurrencyLbl.alpha = 1
                    self.destinationCurrencyLbl.alpha = 1
                    self.compareBtnProdHead.alpha = 1
                    self.prodHeadProdLbl.alpha = 1
                    self.prodHeadArbLbl.alpha = 1
                    self.prodStackV.isHidden = true
                    self.ProdStackPromptLbl.alpha = 1
                }
            }
            
            self.isDestFull = false
            self.resetAll()
            if onceOffTapInstruction == false {
                baseCurrencyLbl.text = "0"
            }
            
        default:
            break
        }
    }
    
    

    @IBAction func closeCalculatorViewPressed(_ sender: Any) {
        
            self.calculaterView.isHidden = true
        FIRAnalytics.logEvent(withName: "close_Pressed", parameters:nil)
        
    }
    @IBAction func showCalculatorViewPressed(_ sender: UITapGestureRecognizer) {
        
            if onceOffTapInstruction {
                    baseCurrencyLbl.text = "0"
                    onceOffTapInstruction = false
            }
        
            self.calculaterView.isHidden = false
            onceOffTap = true
        
    }
    @IBAction func baseCityBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.bcView.center.x = (self.view.frame.width - self.view.frame.width) + self.bcView.frame.width/2
        }
        self.baseCityBtn.backgroundColor = UIColor(red:112/255, green:34/255, blue:26/255, alpha:1)
        
        self.isBaseFull = true
        self.isDestFull = true
        self.baseCityData.removeAll()
    }
    @IBAction func destCityBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width/2
        }
        self.destCityBtn.backgroundColor = UIColor(red:112/255, green:34/255, blue:26/255, alpha:1)
        self.isBaseFull = true
        self.isDestFull = true
        self.destCityData.removeAll()
        
    }
    
    @IBAction func productRangePressed(sender: UIButton){
        
        print(" ----- test \(runningNumber)")
        
        
        if runningNumber == "" {
            self.prodStackV.alpha = 0
            self.ProdStackPromptLbl.alpha = 1
            
            
        } else {
            self.prodStackV.alpha = 1
            self.ProdStackPromptLbl.alpha = 0
            
        }
        
        if self.destCityData.count > 0 && self.baseCityData.count > 0 {
            
            if self.cityIndexRow != nil {
                
                
                
                if sender.tag == 10{
                    self.productRangeSel = "low"
                    self.survivingBtn.backgroundColor = UIColor(red:192/255,green:57/255,blue:43/255,alpha:1.0)
                    self.chillinBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.ballinBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
                    FIRAnalytics.logEvent(withName: "Dest_City_Sel", parameters: ["City_Range":"\(self.destCities[self.cityIndexRow])_low"])
                    
                    self.animateTable()
                    
                } else if sender.tag == 11 {
                    self.productRangeSel = "norm"
                    self.chillinBtn.backgroundColor = UIColor(red:192/255,green:57/255,blue:43/255,alpha:1.0)
                    self.ballinBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.survivingBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
                    //
                    FIRAnalytics.logEvent(withName: "Dest_City_Sel", parameters: ["City_Range":"\(self.destCities[self.cityIndexRow])_norm"])
                    self.animateTable()
                } else {
                    self.productRangeSel = "high"
                    self.ballinBtn.backgroundColor = UIColor(red:192/255,green:57/255,blue:43/255,alpha:1.0)
                    self.chillinBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.survivingBtn.backgroundColor = UIColor(red:155/255,green:155/255,blue:155/255,alpha:1.0)
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
                    //
                    FIRAnalytics.logEvent(withName: "Dest_City_Sel", parameters: ["City_Range":"\(self.destCities[self.cityIndexRow])_high"])
                    self.animateTable() 
                    
                }
                
            }
        }
        
        
    }
    
    @IBAction func compareBtnPressed(_ sender: Any) {
        self.calculaterView.isHidden = true
        FIRAnalytics.logEvent(withName: "compare_Pressed", parameters:nil)
    }
    //Operators
    @IBAction func onDividePressed(sender: AnyObject){
        
        if self.buttonsEnabled != false {
            processOperation(operation: .Divide)
            displayRunningNumber += " ÷ "
            
            calculationLbl.text = displayRunningNumber
        }
        self.disableBtns()
        
    }
    @IBAction func onMultiplyPressed(sender: AnyObject){
        if self.buttonsEnabled != false {
            processOperation(operation: .Multiply)
            displayRunningNumber += " X "
            calculationLbl.text = displayRunningNumber
        }
        self.disableBtns()
        
    }
    @IBAction func onSubtractPressed(sender: AnyObject){
        if self.buttonsEnabled != false {
            processOperation(operation: .Subtract)
            displayRunningNumber += " - "
            calculationLbl.text = displayRunningNumber
        }
        self.disableBtns()
        
    }
    @IBAction func onAddPressed(sender: AnyObject){
        if self.buttonsEnabled != false {
            processOperation(operation: .Add)
            displayRunningNumber += " + "
            calculationLbl.text = displayRunningNumber
        }
        
        self.disableBtns()
    }
    
    @IBAction func decimalBtnPressed(_ sender: Any) {
        
        if self.decimalEnabled == true {
            runningNumber += "."
            displayRunningNumber += "."
            self.decimalEnabled = false
            decimalBtn.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        
        self.resetAll()
        baseCurrencyLbl.text = "0"
        
    }
    
    func resetAll(){
        self.decimalEnabled = true
        runningNumber.removeAll()
        displayRunningNumber.removeAll()
        decimalBtn.isUserInteractionEnabled = true
        
        
        destinationCurrencyLbl.text = "0"
        calculationLbl.text = "0"
        self.swipeInstructLbl.alpha = 0
        self.cokeDestLbl.text = "0x"
        self.domBeerDestLbl.text = "0x"
        self.oneWayTicketLbl.text = "0x"
        self.mealDestLbl.text = "0x"
        self.mcmealDestLbl.text = "0x"
        
        self.prodStackV.isHidden = true
        
        if self.baseCities.count > 0 && self.destCities.count > 0 {
            self.ProdStackPromptLbl.alpha = 1
        }
        
        currentOperation = Operation.Empty
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        displayRunningNumber = ""
        result = "0"
        
        if self.baseCities.count > 0 && self.destCities.count > 0 {
            self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
        }

    }
    
    func disableBtns(){
        divideBtn.isUserInteractionEnabled = false
        subtractBtn.isUserInteractionEnabled = false
        multiplyBtn.isUserInteractionEnabled = false
        addBtn.isUserInteractionEnabled = false
        
        self.buttonsEnabled = false
    }
    
    func enableBtns(){
        divideBtn.isUserInteractionEnabled = true
        subtractBtn.isUserInteractionEnabled = true
        multiplyBtn.isUserInteractionEnabled = true
        addBtn.isUserInteractionEnabled = true
        
        self.buttonsEnabled = true
    }
    
    func liveOperation(operation:Operation){
        
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                
                rightValStr = runningNumber
                
                if currentOperation == Operation.Multiply {
                    result = "\(Float(leftValStr)! * Float(rightValStr)!)"
                } else if currentOperation == Operation.Divide{
                    result = "\(Float(leftValStr)! / Float(rightValStr)!)"
                } else if currentOperation == Operation.Subtract{
                    result = "\(Float(leftValStr)! - Float(rightValStr)!)"
                } else if currentOperation == Operation.Add{
                    result = "\(Float(leftValStr)! + Float(rightValStr)!)"
                }
                
                baseCurrencyLbl.text = result
            }
        }
        
    }
    func processOperation(operation: Operation){
        
        decimalBtn.isUserInteractionEnabled = true
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Float(leftValStr)! * Float(rightValStr)!)"
                } else if currentOperation == Operation.Divide{
                    result = "\(Float(leftValStr)! / Float(rightValStr)!)"
                } else if currentOperation == Operation.Subtract{
                    result = "\(Float(leftValStr)! - Float(rightValStr)!)"
                } else if currentOperation == Operation.Add{
                    result = "\(Float(leftValStr)! + Float(rightValStr)!)"
                }
                
                leftValStr = result
                baseCurrencyLbl.text = result
                
                //Does Converstion
                if self.destCurrSel != nil && self.baseCurrSel != nil && result != "" {
                    let stringResult = Float(result)!
                    let priceToConver = Float(stringResult)
                    
                    let convertedAmount = self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver)
                    
                    destinationCurrencyLbl.text = "\(convertedAmount)"
                }
                
            } else {
                print("rightVal Is empty")
            }
            calculationLbl.text = result
            currentOperation = operation
        }else {
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func globalProdAmount() {
        //        print(" --running: globalProdAmount() ")
        let stringResult = Float(result)!
        let priceToConver = Float(round(stringResult))
        let convertedAmount = Float(self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver))!
        
        
        if self.destCities.count > 0 {
            self.productAmount(convAm: convertedAmount)
        }
        
    }
    
    func getDestCitiesProd(countryKey:String, cityKey: String, productRange: String){
//        print("--- running: getDestCitiesProd")
        
        DataService.ds.REF_CITIES.child(countryKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    if let countryCityDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let destCityProdData = CityData(cityName:key, countryName:countryKey, productData:countryCityDict)
             
                            self.destCityData.append(destCityProdData)

                        for i in (0..<self.destCityData.count){
                            if (self.destCityData[i].cityName == cityKey) {
                                self.destProdListDict.removeAll()
                                self.destProdListDict = self.destCityData[i].productData
                                
                            }
                        }
                    }
                }
            }
        })
    }
    func productAmount(convAm: Float){
        
        
        if runningNumber == "" {
            
            self.prodStackV.alpha = 0
            self.ProdStackPromptLbl.alpha = 1
            
            
        } else {
            self.prodStackV.alpha = 1
            self.ProdStackPromptLbl.alpha = 0
            
        }
        
        if self.cityIndexRow != nil {
            
            for i in (0..<self.destCityData.count){
               
                if (destCityData[i].cityName == self.destCities[self.cityIndexRow])
                {
                    let cokeAmount = convAm / Float("\(self.destCityData[i].coke[self.productRangeSel]!)")!
                    let domBeerAmount = convAm / Float("\(self.destCityData[i].domBeer[self.productRangeSel]!)")!
                    let mealAmount = convAm / Float("\(self.destCityData[i].meal[self.productRangeSel]!)")!
                    let mcMealAmount = convAm / Float("\(self.destCityData[i].mcMeal[self.productRangeSel]!)")!
                    let oneWayTicket = convAm / Float("\(self.destCityData[i].oneWayTicket[self.productRangeSel]!)")!
                    
                    self.cokeDestLbl.count(fromValue: 0, to: Float(cokeAmount), withDuration: 2, andAnimationType: .EaseOut, andCouterType: .Int)
                    self.domBeerDestLbl.count(fromValue: 0, to: Float(domBeerAmount), withDuration: 2, andAnimationType: .EaseOut, andCouterType: .Int)
                    self.oneWayTicketLbl.count(fromValue: 0, to: Float(oneWayTicket), withDuration: 2, andAnimationType: .EaseOut, andCouterType: .Int)
                    self.mcmealDestLbl.count(fromValue: 0, to: Float(mcMealAmount), withDuration: 2, andAnimationType: .EaseOut, andCouterType: .Int)
                    self.mealDestLbl.count(fromValue: 0, to: Float(mealAmount), withDuration: 2, andAnimationType: .EaseOut, andCouterType: .Int)
                }
            }
        }        
        self.prodStackV.isHidden = false
        
    }
    func getBaseCitiesProd(countryKey:String, cityKey: String, productRange: String){
        
        DataService.ds.REF_CITIES.child(countryKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    if let countryCityDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let baseCityProdData = CityData(cityName:key, countryName: countryKey, productData:countryCityDict)
                        

                            self.baseCityData.append(baseCityProdData)

                        self.productList = self.baseCityData[0].productListCount
                        for i in (0..<self.baseCityData.count){
                            if (self.baseCityData[i].cityName == cityKey)
                            {
                                self.baseProdListDict.removeAll()
                                self.baseProdListDict = self.baseCityData[i].productData
                                
                            }
                        }
                    }
                }
            }
            
        })
        
    }
    
    @IBAction func numberPressed(sender: UIButton){
        
        if runningNumber == "" {
            self.swipeInstructLbl.alpha = 1
        }
        runningNumber += "\(sender.tag)"
        displayRunningNumber += "\(sender.tag)"
        calculationLbl.text = displayRunningNumber
        
        if currentOperation == Operation.Empty {
            result = runningNumber
        }
        baseCurrencyLbl.text = result
        
        if currentOperation != Operation.Empty {
            liveOperation(operation: currentOperation)
        }
        
        self.enableBtns()
        if self.destCities.count > 0  && self.baseCities.count > 0 {
        self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
        }
        //Does Converstion
        if self.destCurrSel != nil && self.baseCurrSel != nil && result != "" {
            
            let stringResult = Float(result)!
            let priceToConver = Float(round(stringResult))
            let convertedAmount = self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver)
            
            if self.destCityData.count > 0 && self.baseCityData.count > 0 {
                
                if self.destCities.count > 0 {
                    self.productAmount(convAm: Float(convertedAmount)!)
                }
                
            }
            
            destinationCurrencyLbl.text = "\(String(format: "%.2f", Float(convertedAmount)!))"
        }
        
    }
    
    @IBAction func clearButton(_ sender: Any) {
        
        
        if displayRunningNumber != "" && runningNumber != "" {
            displayRunningNumber.remove(at: displayRunningNumber.index(before: displayRunningNumber.endIndex))
            runningNumber.remove(at: runningNumber.index(before: runningNumber.endIndex))
            liveOperation(operation: currentOperation)
            baseCurrencyLbl.text = result
            calculationLbl.text = displayRunningNumber
            
            if self.destCurrSel != nil && self.baseCurrSel != nil && result != "" {
                let stringResult = Float(result)!
                let priceToConver = Float(round(stringResult))
                
                let convertedAmount = self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver)
                
                destinationCurrencyLbl.text = "\(convertedAmount)"
            }
        } else {
            runningNumber.removeAll()
            displayRunningNumber.removeAll()
            baseCurrencyLbl.text = "0"
            destinationCurrencyLbl.text = "0"
            calculationLbl.text = "0"
            currentOperation = Operation.Empty
            leftValStr = ""
            rightValStr = ""
            runningNumber = ""
            displayRunningNumber = ""
            result = "0"
            
            resetAll()

            
            self.swipeInstructLbl.alpha = 0
            self.captionLabel(destCurrencySymbol:self.destCurrSymbol,range:self.productRangeSel,baseCountry:self.baseCountryKey,destCountry:self.destCountryKey)
            
        }
    }
    func reCalc() {
        print("Supposed to reCalc numbers on screen based on new selection")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DestCountrySelSegue" {
            let destVC: DestCurrVC = segue.destination as! DestCurrVC
            destVC.delegate = self
        }
        if segue.identifier == "BaseCounrtySelSegue" {
            let baseVC: BaseCurrVC = segue.destination as! BaseCurrVC
            baseVC.delegate = self
        }
    }
    
    func captionLabel(destCurrencySymbol:String,range:String,baseCountry:String,destCountry:String){
        let stringResult = Float(result)!
        let priceToConver = Float(round(stringResult))
        let convertedAmount = Float(self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver))!
        
        self.isDestFull = true
        self.isBaseFull = true
        
        var prodRange = ""
        
        switch (range)
        {
        case "norm":
            prodRange = "Chillin"
            
        case "low":
            prodRange = "Surviving"
            
        case "high":
            prodRange = "Ballin"
            
        default:
           break
        }
        
        if self.isDestFull && self.isBaseFull {
            
            if convertedAmount > 0 {
                    self.captionLbl.text = "\(destCurrencySymbol) \(Int(convertedAmount)) \(prodRange) in \(self.destCitySel!)"

            } else{
                self.captionLbl.text = "Convert"
            }
            
            self.isDestFull = false
            self.isBaseFull = false
            
        }
    }

    func animateTable() {
        self.productListTableView.reloadData()
        
        let cells = productListTableView.visibleCells
        
        let tableViewHeight = productListTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX:0,y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    // Animations for Buttons
    // They dont have center positions so had to hack a solution
    
    func addBasePulse(){
        let position = CGPoint(x: baseCountrySelSV.center.x - (baseCountryBtn.frame.width - 2.5), y: baseCountrySelSV.center.y)
        let pulse = CountryButtonPulse(numberOfPulses:1, radius:30, position: position)
        pulse.animationDuration = 0.6
        pulse.backgroundColor = UIColor.darkGray.cgColor
        self.view.layer.insertSublayer(pulse, below: baseCountryBtn.layer)
    }
    
    func addDestPulse(){
        let position = CGPoint(x: destCountrySelSV.center.x - (destCountryBtn.frame.width - 2.5), y: destCountrySelSV.center.y)
        let pulse = CountryButtonPulse(numberOfPulses:1, radius:30, position: position)
        pulse.animationDuration = 0.6
        pulse.backgroundColor = UIColor.darkGray.cgColor
        self.view.layer.insertSublayer(pulse, below: destCountryBtn.layer)
    }
    
    
}

