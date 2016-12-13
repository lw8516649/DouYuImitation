//
//  MainViewController.swift
//  DouYuTV
//
//  Created by LW on 16/12/7.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC(storyName: "Home");
        addChildVC(storyName: "Live");
        addChildVC(storyName: "Video");
        addChildVC(storyName: "Follow");
        addChildVC(storyName: "Profile");

    }

    private func addChildVC(storyName : String){
    
        let childVC  = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        addChildViewController(childVC);
    
    }

    
}
