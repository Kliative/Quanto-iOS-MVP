//
//  ViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productListTableView:UITableView!
    
    @IBOutlet weak var calculaterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.productListTableView.delegate = self
        self.productListTableView.dataSource = self
        
        
        calculaterView.center.y = self.view.frame.height + 100
        
        UIView.animate(withDuration: 0.5) {
            self.calculaterView.center.y = self.view.frame.height - self.calculaterView.frame.height/2
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for:indexPath) as? ProductCell{
           
            
            return cell
            
        } else {
            return ProductCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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

}

