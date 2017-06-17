//
//  ViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        self.bcView.center.x = self.view.frame.width - self.bcView.frame.width
        self.dcView.center.x = self.view.frame.width + self.dcView.frame.width
        
        UIView.animate(withDuration: 1) {
            self.calculaterView.center.y = self.view.frame.height - self.calculaterView.frame.height/2
            self.bcView.center.x = self.view.frame.width + self.bcView.frame.width
            self.dcView.center.x = self.view.frame.width - self.dcView.frame.width
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView {
        case productListTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for:indexPath) as? ProductCell{
                return cell
                
            } else {
                return ProductCell()
            }
        case baseCityTableView :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCityCell", for:indexPath) as? CityCell{
                return cell
                
            } else {
                return CityCell()
            }
        case destCityTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DestCityCell", for:indexPath) as? CityCell{
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
//    Dont know how to do this Yet!!ç
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            if tableView == baseCityTableView {
                return "Base City"
            } else if tableView == destCityTableView {
                return "Destination City"
            } else {
                return nil
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch tableView
        {
            case productListTableView:
                return 4
                
            case baseCityTableView:
                return 1
                
            case destCityTableView:
                return 1
                
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView
        {
        case productListTableView:
            print("Hello")
            
        case baseCityTableView:
            UIView.animate(withDuration: 0.5) {
                self.bcView.center.x = (self.view.frame.width - self.view.frame.width) - self.bcView.frame.width
            }
        case destCityTableView:
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

}

