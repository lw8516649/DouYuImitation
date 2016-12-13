//
//  PageContentView.swift
//  DouYuTV
//
//  Created by LW on 16/12/8.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate :class {
    
    func pageContentView(_ contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

fileprivate let ContentCellID = "ContentCellID";

class PageContentView: UIView {
    
    //定义属性
    
    fileprivate var childVCs :[UIViewController] ;
    
    fileprivate weak var parentViewController :UIViewController?;
    
    fileprivate var startOffsetX : CGFloat = 0;
    
    fileprivate var isForbidScrollDelegate = false;
    
    weak  var delegate :PageContentViewDelegate? ;
    //懒加载属性
    
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
    
        //创建 layout
        
        let layout = UICollectionViewFlowLayout ();
        
        layout.itemSize = (self?.bounds.size)!
        //内间距
        layout.minimumLineSpacing = 0;
        //item间距
        layout.minimumInteritemSpacing = 0;
        //滚动方向   水平
        layout.scrollDirection = .horizontal;
        
        //创建uicollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout );
        //水平方向指示器
        collectionView.showsHorizontalScrollIndicator = false;
        //分页显示
        collectionView.isPagingEnabled = true;
        //不超出内容的滚动
        collectionView.bounces = false;
        //遵守协议
        collectionView.dataSource = self;
        
        collectionView.delegate = self;
        //注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView;
    }()

    init(frame: CGRect, childVCs : [UIViewController], parentViewController : UIViewController?) {
        
        self.childVCs = childVCs;
        
        self.parentViewController = parentViewController;
        
        super.init(frame: frame);
       
        setupUI();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageContentView {
    
    fileprivate func setupUI(){
    
        for childVC in childVCs {
        
            //将所有子控制器添加到父控制器
            parentViewController?.addChildViewController(childVC);
            
            //添加uicollectionView，用于cell中存放控制器的view
            addSubview(collectionView);
            
            collectionView.frame = bounds;
        }
        
    }
    

}

extension PageContentView :UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVCs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath);
        
        let childVC = childVCs[indexPath.item];
        
        childVC.view.frame = cell.contentView.bounds;
        
         //给cell 设置内容
        
        for view in cell.contentView.subviews {
        
            view.removeFromSuperview();
        }
       
        cell.contentView.addSubview(childVC.view);
        
        return cell;
    }
}

extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false;
        
        startOffsetX = scrollView.contentOffset.x;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if isForbidScrollDelegate {return}; 
        
        //定义获取需要的数据
        var progress : CGFloat = 0;
        //原本
        var sourceIndex :Int = 0;
        //目标
        var targetIndex :Int = 0;
        
        //判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x;
        
        let scrollViewW = scrollView.bounds.width;
        
        if currentOffsetX > startOffsetX {//左滑
            //计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW) ;
            
            //计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //计算targetIndex
            targetIndex = sourceIndex + 1;
            
            if targetIndex >= childVCs.count {
            
                targetIndex = childVCs.count - 1;
            }
            
            if currentOffsetX - startOffsetX == scrollViewW {
                
                progress = 1;
                
                targetIndex = sourceIndex;
            }
            
        }else{//右滑
            //计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)) ;
            
            //计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            
            //计算sourceIndex
            sourceIndex = targetIndex + 1;
            
            if sourceIndex >= childVCs.count {
                
                sourceIndex = childVCs.count - 1;
            }
        }
        //将 progress sourceIndex targetIndex 传给titleview

        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex);
    } 

}
//对外暴露的方法
extension  PageContentView {
    
    func setCurrentIndex(_ currentIndex :Int){
        
        //记录需要禁止执行代理
        isForbidScrollDelegate = true;
        
        //滚动正确位置
        let offsetX = CGFloat (currentIndex)*collectionView.frame.width;
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false);
    }
    
}
