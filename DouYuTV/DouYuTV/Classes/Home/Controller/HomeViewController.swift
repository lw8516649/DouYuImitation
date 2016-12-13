//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by LW on 16/12/7.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

private let kTitleViewH :CGFloat = 40

class HomeViewController: UIViewController {

    fileprivate lazy var pageTitleView : PageTitleView = { [weak self] in
         
        let titleFrame = CGRect (x: 0, y: kStatusBarH + kNavigatinoBarH, width: kScreenW, height: kTitleViewH );
        
        let titles = ["推荐","手游","娱乐","游戏","趣玩"];
        
        let titleView = PageTitleView(frame: titleFrame , titles: titles);
        
        titleView.deleate = self;
        
        return titleView;
        
        }()
    
    fileprivate lazy var pageContentView :PageContentView = {[weak self] in
        
        //设置内容fram
        let contentH = kScreenH - kStatusBarH - kTitleViewH - kNavigatinoBarH - kTabarH;
        
        let contentFrame = CGRect(x: 0, y: kStatusBarH+kNavigatinoBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //设置子控制器
        var childVCs = [UIViewController]();
        
        childVCs.append(RecommendedViewController());
        for _ in 0..<4 {
            
            let vc = UIViewController();
            
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)) , g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)));
            
            childVCs.append(vc);
            
        }

        let contentView = PageContentView (frame: contentFrame, childVCs: childVCs, parentViewController: self)
        
        contentView.delegate = self;

        return contentView;
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        setupUI()
    }
}



extension HomeViewController {

    fileprivate func setupUI(){
        //不需要scrollView 内边距 
        automaticallyAdjustsScrollViewInsets = false;
    
        //设置导航栏
        setupNavigationBar()
        //添加titleView
        view.addSubview(pageTitleView);
        //添加contentView
        view.addSubview(pageContentView);
        
    }
    
    fileprivate func setupNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"homeLogoIcon");
        
        let size = CGSize (width: 40, height: 40);
        
        let messageItem = UIBarButtonItem(imageName:"siteMessageHome", hightImageName: "siteMessageHomeH", size: size);
        
        let historyItem = UIBarButtonItem(imageName:"viewHistoryIcon", hightImageName: "viewHistoryIconHL", size: size);
        
        let scanItem = UIBarButtonItem(imageName:"scanIcon", hightImageName: "scanIconHL", size: size);
        
        let searchItem = UIBarButtonItem(imageName:"searchBtnIcon", hightImageName: "searchBtnIconHL", size: size);
        
        navigationItem.rightBarButtonItems = [searchItem,scanItem,historyItem,messageItem];
    
    
    }

}

// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController :pageTitleViewDelegate {

    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        
        pageContentView.setCurrentIndex(index);
        
    }
}

// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController :PageContentViewDelegate{
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
}
