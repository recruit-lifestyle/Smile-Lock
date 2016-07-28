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
    
    var isShowed = false
    var loginVCID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVCID = isBlurUI ? "BlurPasswordLoginViewController" : "PasswordLoginViewController"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !isShowed {
            self.isShowed = true
            self.present(self.loginVCID)
        }
    }
    
    @IBAction func presentLoginVC(sender: AnyObject) {
        self.present(self.loginVCID)
    }
    
    func present(id: String) {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier(id)
        loginVC?.modalTransitionStyle = .CrossDissolve
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }

}
