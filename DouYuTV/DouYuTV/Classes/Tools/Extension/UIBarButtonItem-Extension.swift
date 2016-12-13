//
//  UIBarButtonItem-Extension.swift
//  DouYuTV
//
//  Created by LW on 16/12/7.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    convenience init(imageName : String, hightImageName : String = "", size : CGSize = CGSize.zero) {
        
        let btn = UIButton();
        
        btn.setImage(UIImage(named: imageName), for: .normal);
        
        if hightImageName != "" {
        
            btn.setImage(UIImage(named: hightImageName), for: .highlighted);
        
        }
        
        if size == CGSize.zero {
        
            btn.sizeToFit();
        
        }else{
        
            btn.frame = CGRect (origin: CGPoint.zero, size: size);
            
        }
    
        self.init(customView : btn);
        
    }


}
