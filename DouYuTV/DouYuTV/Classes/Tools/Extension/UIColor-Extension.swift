//
//  UIColor-Extension.swift
//  DouYuTV
//
//  Created by LW on 16/12/8.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0);
    }
}
