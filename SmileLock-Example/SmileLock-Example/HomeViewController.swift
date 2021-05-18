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
        loginVCID = isBlurUI ? "BlurPasswordLoginViewController" : "PasswordLoginViewController"
    }
    
    @IBAction func presentLoginVC(_ sender: AnyObject) {
        present(loginVCID)
    }
    
    func present(_ id: String) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: id)
        // in iOS 10, the crossDissolve transtion is wired
//        loginVC?.modalTransitionStyle = .crossDissolve
        loginVC?.modalPresentationStyle = .overCurrentContext
        present(loginVC!, animated: true, completion: nil)
    }
}
