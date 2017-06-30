//
//  OnBoardingVCViewController.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/30.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit

class OnBoardingVCViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    func onboardingItemsCount() -> Int {
        return 5
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let bgWhite = UIColor(red:255/255, green:255/255, blue:255/255,alpha:1)
        let bgRed = UIColor(red:192/255, green:57/255, blue:43/255,alpha:1)
        let bgDGrey = UIColor(red:74/255, green:74/255, blue:74/255,alpha:1)
        let bgDDGrey = UIColor(red:50/255, green:50/255, blue:50/255,alpha:1)
        
        let titleFont = UIFont(name:"AppleSDGothicNeo-Regular",size: 24)
        let descriptionFont = UIFont(name:"AppleSDGothicNeo-Thin",size: 18)
        
        return[("logoWhiteWT","Welcome to Quanto","See how much products cost in the cities you are visting","",bgRed,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("convertWT","Convert","You can use Quanto as a standard Currency Converter or","",bgDDGrey,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("conAmountWT","Calculate","See how many products your converted amount can buy you","",bgDGrey,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("compareWT","Product Comparison","Compare product prices with products in different Cities","",bgRed,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("logoWT","","","",bgWhite,bgRed,bgRed,titleFont,descriptionFont)
            ][index] as! OnboardingItemInfo
    }
    
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index <= 4 {
            if self.getStartedBtn.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedBtn.alpha = 0
                })
                
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 4 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.getStartedBtn.alpha = 1
            })
            
        }
    }
    @IBAction func getStartedPressed(_ sender: Any) {
        //        let userDefaults = UserDefaults.standard
        //
        //        userDefaults.set(true, forKey: "onboardingComplete")
        //        userDefaults.synchronize()
    }
    
}

