//
//  BaseCurrVC.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/19.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol baseDataSentDelegate {
    func userDidEnterBaseData(data: CountryData)
}

class BaseCurrVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    var countryData = [CountryData]()
    
    var cityNameArray:[String] = []
    var countryNameArray:[String] = []
    
    let searchController = UISearchController(searchResultsController:nil)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isSearching = false
    
    
    var filterData = [CountryData]()
    
    
    var sortedCurrency:[String] = []
    
    var currentRates: CurrentExchange!
    var delegate: baseDataSentDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red:192/255, green:57/255, blue:43/255,alpha:1)
        
        searchController.searchBar.placeholder = "Base Country"
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        
        DataService.ds.REF_COUNTRIES.observe(.value, with: { (snapshot) in
            self.countryData = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    
                    if let countryDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let countryDataSnap = CountryData(countryName:key,
                                                          currencyCode: countryDict["ISO4217_currency_alphabetic_code"] as! String,
                                                          currencyName: countryDict["ISO4217_currency_name"] as! String,
                                                          currencySymbol: countryDict["ISO4217_currency_symbol"] as! String,
                                                          capitalName:countryDict["Capital"] as! String,
                                                          cities:countryDict["cities"] as! [String],
                                                          countryCode: countryDict["ISO3166_1_Alpha_2"] as! String)
                        
                        self.countryData.append(countryDataSnap)
                        
                        self.countryNameArray.append(key)
//                        self.tableView.insertRows(at: [IndexPath(row:self.countryData.count-1,section:0)], with: UITableViewRowAnimation.automatic)
                        self.cityNameArray = countryDict["cities"] as! [String]
                        
                        //                        print(countryDict["Capital"] as! String)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Assign correct Cell to countryData indexPath.row
        let countryData : CountryData
        
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            countryData = self.filterData[indexPath.row]
            
        } else {
            countryData = self.countryData[indexPath.row]
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCurrCell", for:indexPath) as? CurrencyCell{
            
            
            //sends throught country Name to cells, create better cellconfig and add more data
            cell.configureCurrencyCell(countryName: countryData.countryName, countryCode: countryData.countryCode, currencyName: countryData.currencyName)
            
            return cell
            
        } else {
            return CurrencyCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""{
            return self.filterData.count
        } else {
            return countryData.count
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Assign correct Cell to countryData indexPath.row
        let countryData : CountryData
        
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            countryData = self.filterData[indexPath.row]
            
        }
        else
        {
            countryData = self.countryData[indexPath.row]
        }
        //send back the currency Code, see if you can send the whole object :) :)
        delegate?.userDidEnterBaseData(data: countryData)
        
        dismiss(animated: true) {
//            MainVC().reCalc()
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    
    
    @IBAction func dismissBaseVCPressed(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    
    func filterContent(searchText:String)
    {
        self.filterData = self.countryData.filter{ country in
            
            let countryNameFilterdList = country.countryName
            return(countryNameFilterdList.lowercased().contains(searchText.lowercased()))
            
        }
        
        tableView.reloadData()
    }
    
}
