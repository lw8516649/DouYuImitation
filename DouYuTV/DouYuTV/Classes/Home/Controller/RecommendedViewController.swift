//
//  RecommendedViewController.swift
//  DouYuTV
//
//  Created by LW on 16/12/12.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10;

private let kItemW  = (kScreenW - 3 * kItemMargin) / 2;

private let KItemH  = kItemW * 3 / 4;

private let kHeaderViewH :CGFloat = 50;

private let kNormalCellID  = "kNormalCellID";

private let kHeaderViewCellID  = "kHeaderViewCellID";

class RecommendedViewController: UIViewController {

    fileprivate lazy var collectionView : UICollectionView = {
    
        let layout = UICollectionViewFlowLayout();
        
        layout.itemSize = CGSize(width: kItemW, height: KItemH);
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = kItemMargin ;
        
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin);
        
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH);
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
        
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth];
        
        collectionView.backgroundColor = UIColor.white;
        
        collectionView.dataSource = self;
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellID)
        
        return collectionView;
    }()
    
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple;
        
        setUI();
        
        
        
        
   
    }

  
}

extension RecommendedViewController {
    
    
    fileprivate func setUI() {
    
        view.addSubview(collectionView);
    
    }

}

extension RecommendedViewController :UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12 ;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            
            return 8;
            
        }
        return 4 ;
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath);
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewCellID, for: indexPath);
        
        return headerView;
        
    }

}
