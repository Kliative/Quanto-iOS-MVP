//
//  Constants.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/19.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import Foundation

let LASTEST_PROD_RATES = "https://openexchangerates.org/api/latest.json?app_id=8189c190e69d471fb0b4abfba0a7c023"
let LASTEST_DEV_RATES = "https://openexchangerates.org/api/latest.json?app_id=62d91899a3644c529320ae9701b2efd3"
let LASTEST_DEV_RATES_F = "https://openexchangerates.org/api/latest.json?app_id=ed2b92aa8a6aed291c4eb80eb9c"


//Need to upgrade account for these features
let BASE_URL = "https://openexchangerates.org/api/convert/"
let PRICE = "1000"
let BASE_CURRENCY = "ZAR"
let DEST_CURRENCY = "EUR"
let APP_ID_KEY = "?app_id=8189c190e69d471fb0b4abfba0a7c023"
let APP_ID_DEV_KEY = "?app_id=ed2b92aa8ad845d6aed291c4eb80eb9c"

let CALC_URL = "\(BASE_URL)\(PRICE)/\(DEST_CURRENCY)/\(BASE_CURRENCY)\(APP_ID_KEY)"
let CALC_DEV_URL = "\(BASE_URL)\(PRICE)/\(DEST_CURRENCY)/\(BASE_CURRENCY)\(APP_ID_DEV_KEY)"


typealias DownloadComplete = () -> ()
