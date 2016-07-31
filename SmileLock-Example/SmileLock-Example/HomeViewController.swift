//
//  HomeViewController.swift
//  SmileLock-Example
//
//  Created by rain on 7/28/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Property
    let isBlurUI = true
    
    var loginVCID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVCID = isBlurUI ? "BlurPasswordLoginViewController" : "PasswordLoginViewController"
    }
    
    @IBAction func presentLoginVC(sender: AnyObject) {
        self.present(self.loginVCID)
    }
    
    func present(id: String) {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(id)
        loginVC?.modalTransitionStyle = .CrossDissolve
        loginVC?.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }
}
