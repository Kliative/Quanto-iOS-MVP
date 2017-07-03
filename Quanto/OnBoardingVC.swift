//
//  OnBoardingVC.swift
//  Quanto
//
//  Created by Tawanda Kanyangarara on 2017/06/30.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import UIKit
import paper_onboarding

class OnBoardingVC: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    

    @IBOutlet weak var onboardingView: OnBoarding!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        onboardingView.dataSource = self
        onboardingView.delegate = self
        
        self.getStartedBtn.alpha = 0
        self.getStartedBtn.layer.bounds = CGRect(x:0,y:0,width:100,height:100)
        self.getStartedBtn.layer.cornerRadius = 2
    }
    
    func onboardingItemsCount() -> Int {
        return 5
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let bgWhite = UIColor(red:255/255, green:255/255, blue:255/255,alpha:1)
        let bgRed = UIColor(red:192/255, green:57/255, blue:43/255,alpha:1)
        let bgYellow = UIColor(red:252/255, green:210/255, blue:140/255,alpha:1)
        let bgDGrey = UIColor(red:74/255, green:74/255, blue:74/255,alpha:1)
        let bgDDGrey = UIColor(red:50/255, green:50/255, blue:50/255,alpha:1)
        
        let titleFont = UIFont(name:"AppleSDGothicNeo-Regular",size: 24)
        let descriptionFont = UIFont(name:"AppleSDGothicNeo-Regular",size: 18)
        
        return[("logoWhiteWT","Welcome to Quanto","The app that shows you how much products cost in the cities you are visting. Before or During your Trip","",bgRed,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("convertWT","Convert","Quanto can be a standard Currency Converter.","",bgDDGrey,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("conAmountWT","Calculate","See how many products your converted amount can buy you.","",bgDGrey,UIColor.white,UIColor.white,titleFont,descriptionFont),
               ("compareWT","Compare","Compare product prices with products in different cities.","",bgYellow,UIColor.darkGray,UIColor.darkGray,titleFont,descriptionFont),
               ("logoWT","","Money is only a tool. It will take you wherever you wish, but it will not replace YOU as the driver. \n \n ~Ayn Rand","",bgWhite,bgRed,bgRed,titleFont,descriptionFont)
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

