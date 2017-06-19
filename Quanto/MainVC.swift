//
//  ViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource,baseDataSentDelegate, destDataSentDelegate {
    
    var destCityData = [CityData]()
    var baseCityData = [CityData]()
    var baseCapitalData = [CityData]()
    
    var productList:Int!
    var destProdListDict: Dictionary<String, AnyObject>!
    var baseProdListDict: Dictionary<String, AnyObject>!
    var capitalName:String!
    
    var isBaseFull = false
    var isDestFull = false
    
    var baseCities:[String] = []
    var destCities:[String] = []
    
    
    @IBOutlet weak var cokeDestLbl: UILabel!
    @IBOutlet weak var domBeerDestLbl: UILabel!
    @IBOutlet weak var mealDestLbl: UILabel!
    @IBOutlet weak var oneWayTicketLbl: UILabel!
    @IBOutlet weak var mcmealDestLbl: UILabel!

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
        

        
        self.baseCountryBtn.contentHorizontalAlignment = .left
        self.destCountryBtn.contentHorizontalAlignment = .left
        
        calculaterView.center.y = self.view.frame.height + 100
        
        self.bcView.center.x = (self.view.frame.width - self.view.frame.width) - self.dcView.frame.width
        self.dcView.center.x = self.view.frame.width + self.dcView.frame.width
        
        UIView.animate(withDuration: 1) {
            self.calculaterView.center.y = self.view.frame.height - self.calculaterView.frame.height/2
            self.bcView.center.x = (self.view.frame.width - self.view.frame.width) + self.bcView.frame.width/2
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width/2
        }
        
        currentRates = CurrentExchange()
        currentRates.downloadExchangeRates {}
        
        self.decimalEnabled = true
        decimalBtn.isUserInteractionEnabled = true
        
        calculationLbl.text = "0"
        baseCurrencyLbl.text = "0"
        destinationCurrencyLbl.text = "0"
        destinationCurrencyLbl.textColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.2)
        
        self.cokeDestLbl.text = "0 x"
        self.domBeerDestLbl.text = "0 x"
        self.oneWayTicketLbl.text = "0 x"
        self.mealDestLbl.text = "0 x"
        self.mcmealDestLbl.text = "0 x"
        
        
        self.productRangeSel = "norm"
        
        self.destProdListDict = [:]
        self.baseProdListDict = [:]
        
        self.disableBtns()
        
        if self.destCurrSel == nil || self.baseCurrSel == nil {
            self.destCurrSel = "ZAR"
            self.baseCurrSel = "GBP"
            self.baseCountryBtn.setTitle("United Kingdom [GBP]", for: .normal)
            self.destCountryBtn.setTitle("South Africa [ZAR]", for: .normal)
            
        }

    }
    
    func userDidEnterDestData(data: CountryData) {
        self.destCountryKey = data.countryName
        self.destCountryBtn.setTitle("\(data.countryName) [\(data.currencyCode)]", for: .normal)
        self.destCurrSel = data.currencyCode
        self.destCurrSymbol = data.currencySymbol
        self.destCities = data.cities
        self.destCapital = data.capitalName
        self.getDestCitiesProd(countryKey: data.countryName
            , cityKey: data.capitalName, productRange: self.productRangeSel)
        
        self.globalProdAmount()
        print("userDidEnterDestData")
        self.destCityTableView.reloadData()
        
        
    }
    
    func userDidEnterBaseData(data: CountryData) {
        self.baseCountryKey = data.countryName
        self.baseCountryBtn.setTitle("\(data.countryName) [\(data.currencyCode)]", for: .normal)
        self.baseCurrSel = data.currencyCode
        self.baseCities = data.cities
        self.baseCurrSymbol = data.currencySymbol
        self.getBaseCitiesProd(countryKey: data.countryName
            , cityKey: data.capitalName, productRange: self.productRangeSel)
        print("userDidEnterBaseData")
        self.baseCityTableView.reloadData()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView {
        case productListTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for:indexPath) as? ProductCell{
                cell.configureProductCell(productRange:self.productRangeSel, baseCurr:self.baseCurrSel, destCurr: self.destCurrSel, destCurrSymbol: self.destCurrSymbol, baseCurrSymbol: self.baseCurrSymbol, indexPath: indexPath.row, baseCityProdList: self.baseProdListDict, destCityProdList: self.destProdListDict)
                
                return cell
            } else {
                return ProductCell()
            }
        case baseCityTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCityCell", for:indexPath) as? CityCell{
                cell.configureCityCell(cityName: self.baseCities[indexPath.row])
                
                return cell
                
            } else {
                return CityCell()
            }
        case destCityTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DestCityCell", for:indexPath) as? CityCell{
                cell.configureCityCell(cityName: self.destCities[indexPath.row])
                
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
//    Dont know how to do this Yet!!
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        let headerView = UIView()
//        
//       
//            label.textColor = UIColor.white
//            headerView.backgroundColor = UIColor.init(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
//        
//            headerView.addSubview(label)
//            return headerView
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//            if tableView == baseCityTableView {
//                return "Base City"
//            } else if tableView == destCityTableView {
//                return "Destination City"
//            } else {
//                return nil
//            }
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if tableView == self.destCityTableView {
//            return self.destCities.count
//        } else if tableView == self.baseCityTableView {
//            return self.baseCities.count
//        } else {
//            
//            if self.baseProdListDict.count == self.destProdListDict.count {
//                return self.baseProdListDict.count
//            } else {
//                return self.baseCityData.count
//            }
//            
//        }
        
        switch tableView
        {
            case productListTableView:
                if self.baseProdListDict.count == self.destProdListDict.count {
                    return self.baseProdListDict.count
                } else {
                    return self.baseCityData.count
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
        
        self.cityIndexRow = indexPath.row
        
        switch tableView
        {
        case productListTableView:
            print("Hello")
            
        case baseCityTableView:
            self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
            
            self.isBaseFull = true
            
            if self.isDestFull && self.isBaseFull {
                self.productListTableView.reloadData()
            }
            UIView.animate(withDuration: 0.5) {
                self.bcView.center.x = (self.view.frame.width - self.view.frame.width) - self.bcView.frame.width
            }
        case destCityTableView:
            self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
            
            self.isDestFull = true
            
            if self.isDestFull && self.isBaseFull {
                self.productListTableView.reloadData()
            }
            UIView.animate(withDuration: 0.5) {
               self.dcView.center.x = self.view.frame.width + self.dcView.frame.width
            }
        default:
            break
        }
    }
    
    @IBAction func closeCalculatorViewPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.calculaterView.center.y = self.view.frame.height + 200
        }
    }
    @IBAction func showCalculatorViewPressed(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.calculaterView.center.y = self.view.frame.height - self.calculaterView.frame.height/2
        }
    }
    @IBAction func baseCityBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.bcView.center.x = (self.view.frame.width - self.view.frame.width) + self.bcView.frame.width/2
        }
    }
    @IBAction func destCityBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width/2
        }
    }
    
    @IBAction func productRangePressed(sender: UIButton){
        
        if self.destCityData.count > 0 && self.baseCityData.count > 0 {
            
            
            if self.cityIndexRow != nil {
                
                if sender.tag == 10{
                    self.productRangeSel = "low"
                    
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    self.productListTableView.reloadData()
                    
                } else if sender.tag == 11 {
                    self.productRangeSel = "norm"
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    self.productListTableView.reloadData()
                } else {
                    self.productRangeSel = "high"
                    self.getDestCitiesProd(countryKey: self.destCountryKey, cityKey: self.destCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.getBaseCitiesProd(countryKey: self.baseCountryKey, cityKey: self.baseCities[self.cityIndexRow], productRange: self.productRangeSel)
                    self.globalProdAmount()
                    self.productListTableView.reloadData()
                    
                }
                
            }
        }
        
        
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
        
        runningNumber.removeAll()
        displayRunningNumber.removeAll()
        
        baseCurrencyLbl.text = "0"
        destinationCurrencyLbl.text = "0"
        calculationLbl.text = "0"
        self.cokeDestLbl.text = "0"
        self.domBeerDestLbl.text = "0"
        self.oneWayTicketLbl.text = "0"
        self.mealDestLbl.text = "0"
        self.mcmealDestLbl.text = "0"
        currentOperation = Operation.Empty
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        displayRunningNumber = ""
        result = "0"
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
        self.decimalEnabled = true
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
                    let priceToConver = Float(round(stringResult))
                    
                    let convertedAmount = Float(self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver))!
                    
                    destinationCurrencyLbl.text = "\(Float(round(convertedAmount)))"
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
        print("--- running: getDestCitiesProd")
        DataService.ds.REF_CITIES.child(countryKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    if let countryCityDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let destCityProdData = CityData(cityName:key, countryName:countryKey, productData:countryCityDict)
                        
                        if self.destCityData.isEmpty {
                            self.destCityData.append(destCityProdData)
                        } else {
                            self.destCityData.removeAll()
                            self.destCityData.append(destCityProdData)
                        }
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
        print("--productAmount")
        if self.cityIndexRow != nil {
            print("--cityIndexRow")
            for i in (0..<self.destCityData.count){
                if (destCityData[i].cityName == self.destCities[self.cityIndexRow])
                {
                    let cokeAmount = convAm / Float("\(self.destCityData[i].coke[self.productRangeSel]!)")!
                    let domBeerAmount = convAm / Float("\(self.destCityData[i].domBeer[self.productRangeSel]!)")!
                    let mealAmount = convAm / Float("\(self.destCityData[i].meal[self.productRangeSel]!)")!
                    let mcMealAmount = convAm / Float("\(self.destCityData[i].mcMeal[self.productRangeSel]!)")!
                    let oneWayTicket = convAm / Float("\(self.destCityData[i].oneWayTicket[self.productRangeSel]!)")!
                    
                    self.cokeDestLbl.text = "\(Int(cokeAmount))x"
                    self.domBeerDestLbl.text = "\(Int(domBeerAmount))x"
                    self.mcmealDestLbl.text = "\(Int(mcMealAmount))x"
                    self.oneWayTicketLbl.text = "\(Int(oneWayTicket))x"
                    self.mealDestLbl.text = "\(Int(mealAmount))x"
                }
            }
        } else {
            print("--destCapital")
            print(self.destCityData.count)
            for i in (0..<self.destCityData.count){
                if (destCityData[i].cityName == self.destCapital)
                {
                    let cokeAmount = convAm / Float("\(self.destCityData[i].coke[self.productRangeSel]!)")!
                    let domBeerAmount = convAm / Float("\(self.destCityData[i].domBeer[self.productRangeSel]!)")!
                    let mealAmount = convAm / Float("\(self.destCityData[i].meal[self.productRangeSel]!)")!
                    let mcMealAmount = convAm / Float("\(self.destCityData[i].mcMeal[self.productRangeSel]!)")!
                    let oneWayTicket = convAm / Float("\(self.destCityData[i].oneWayTicket[self.productRangeSel]!)")!
                    
                    self.cokeDestLbl.text = "\(Int(cokeAmount))x"
                    self.domBeerDestLbl.text = "\(Int(domBeerAmount))x"
                    self.oneWayTicketLbl.text = "\(Int(oneWayTicket))x"
                    self.mcmealDestLbl.text = "\(Int(mcMealAmount))x"
                    self.mealDestLbl.text = "\(Int(mealAmount))x"
                }
            }
        }
        
        
        
    }
    func getBaseCitiesProd(countryKey:String, cityKey: String, productRange: String){
        print("--- running: getBaseCitiesProd")
        DataService.ds.REF_CITIES.child(countryKey).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    if let countryCityDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let baseCityProdData = CityData(cityName:key, countryName: countryKey, productData:countryCityDict)
                        
                        if self.baseCityData.isEmpty {
                            self.baseCityData.append(baseCityProdData)
                        } else {
                            self.baseCityData.removeAll()
                            self.baseCityData.append(baseCityProdData)
                        }
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
        
        //Does Converstion
        if self.destCurrSel != nil && self.baseCurrSel != nil && result != "" {
            
            let stringResult = Float(result)!
            let priceToConver = Float(round(stringResult))
            let convertedAmount = Float(self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver))!
            
            if self.destCityData.isEmpty && self.baseCityData.isEmpty {
                
            } else {
                
                if self.destCities.isEmpty {
                    
                } else {
                    self.productAmount(convAm: convertedAmount)
                }
                
            }
            
            destinationCurrencyLbl.text = "\(Float(round(convertedAmount)))"
//            destinationCurrencyLbl.textColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:1)
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
                
                let convertedAmount = Float(self.currentRates.doConvertion(dest: self.destCurrSel, base: self.baseCurrSel, price: priceToConver))!
                
                destinationCurrencyLbl.text = "\(Float(round(convertedAmount)))"
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


}

