//
//  ViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productListTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.productListTableView.delegate = self
        self.productListTableView.dataSource = self
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
        return 1
    }

}

