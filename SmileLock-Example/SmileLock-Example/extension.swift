//
//  extension.swift
//  SmileLock-Example
//
//  Created by yuchen liu on 4/24/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

enum ColorType: String {
    case Blue = "20aee5"
    case TextColor = "555555"
}

extension UIColor {
    
    class func hexStr(hexStr: NSString) -> UIColor {
        return UIColor.hexStr(hexStr, alpha: 1)
    }
    
    class func color(hexColor:ColorType) -> UIColor {
        return UIColor.hexStr(hexColor.rawValue, alpha: 1.0)
    }
    
    class func hexStr (Str : NSString, alpha : CGFloat) -> UIColor {
        let hexStr = Str.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.whiteColor();
        }
    }
    
}
