//
//  BlurPasswordLoginViewController.swift
//
//  Created by rain on 4/22/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit
import SmileLock

class BlurPasswordLoginViewController: UIViewController {

    @IBOutlet weak var passwordStackView: UIStackView!
    
    //MARK: Property
    var passwordUIValidation: MyPasswordUIValidation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create PasswordUIValidation subclass
        self.passwordUIValidation = MyPasswordUIValidation(in: passwordStackView)
        
        self.passwordUIValidation.success = { [weak self] _ in
            print("*️⃣ success!")
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.passwordUIValidation.failure = { _ in
            //do not forget add [weak self] if the view controller become nil at some point during its lifetime
            print("*️⃣ failure!")
        }
        
        //visual effect password UI
        self.passwordUIValidation.view.rearrangeForVisualEffectView(in: self)
    }
}
