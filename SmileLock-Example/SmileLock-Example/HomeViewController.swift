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
    
    @IBAction func presentLoginVC(_ sender: AnyObject) {
        self.present(self.loginVCID)
    }
    
    func present(_ id: String) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: id)
        loginVC?.modalTransitionStyle = .crossDissolve
        loginVC?.modalPresentationStyle = .overCurrentContext
        self.present(loginVC!, animated: true, completion: nil)
    }
}
