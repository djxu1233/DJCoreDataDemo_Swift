//
//  UIColor+DJExtension.swift
//  DJSwiftExtensionDemo
//
//  Created by minstone.DJ on 2020/3/19.
//  Copyright © 2020 minstone. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.init(red: r / 255.0,
                            green: g / 255.0,
                            blue: b / 255.0,
                            alpha: 1.0)
    }
    
    static func hex(_ Hex: UInt32) -> UIColor {
        return UIColor.init(red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((Hex & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((Hex & 0xFF)) / 255.0,
                            alpha: 1.0)
    }
    
    /// 随机颜色
    static func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                       green: CGFloat(arc4random_uniform(256)) / 255.0,
                       blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
    
    
    convenience init(hexString: String) {
        
        var cString = hexString.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
       
        if cString.hasPrefix("0X") {
            
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString.suffix(from: index))
            
        }
        if (cString.hasPrefix("#")) {
            
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = String(cString.suffix(from: index))
            
        }
       
        if (cString.count != 6) { // 输入错误返回红色
            self.init(red: 1, green: 0, blue: 0, alpha: 1)
        } else {
           
            let rIndex = cString.index(cString.startIndex, offsetBy: 2)
            let rString = cString.prefix(upTo: rIndex)
            let otherString = cString.suffix(from: rIndex)
            
            let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
            let gString = otherString.prefix(upTo: gIndex)
            
            let bIndex = cString.index(cString.endIndex, offsetBy: -2)
            let bString = cString.suffix(from: bIndex)
            
            var r:UInt64 = 0, g:UInt64 = 0, b:UInt64 = 0;
            
            Scanner.init(string: String(rString)).scanHexInt64(&r)
            Scanner.init(string: String(gString)).scanHexInt64(&g)
            Scanner.init(string: String(bString)).scanHexInt64(&b)

            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
       }
   }
    
}

