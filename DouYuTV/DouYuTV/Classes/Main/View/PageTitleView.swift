//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by LW on 16/12/8.
//  Copyright © 2016年 LW. All rights reserved.
//

import UIKit
//定义协议
protocol pageTitleViewDelegate : class {
    
    func pageTitleView(titleView : PageTitleView, selectedIndex index :Int)
}
//定义常亮
private let kScrollLineH :CGFloat = 2 ;
private let kNormalColor :(CGFloat,CGFloat,CGFloat) = (85,85,85) ;
private let kSelectColor :(CGFloat,CGFloat,CGFloat) = (255,128,0) ;

//定义类
class PageTitleView: UIView {
    
    //设置pageTitleeView属性
    fileprivate var currentIndex :Int = 0;
    
    fileprivate var titles : [String];
    
    weak var deleate : pageTitleViewDelegate?
    
    //懒加载
    
    fileprivate lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView ();
        
        //水平指示器
        scrollView.showsHorizontalScrollIndicator = false;
        //是否返回到顶部
        scrollView.scrollsToTop = false;
        //不能超过内容范围
        scrollView.bounces = false;
        
        return scrollView;
    
    }()
    
    fileprivate lazy var scrollLine :UIView = {
        
        let scrollLine = UIView();
        
        scrollLine.backgroundColor = UIColor.orange;
        
        return scrollLine;
        
    }()
    
    fileprivate lazy var titleLabels :[UILabel] = [UILabel]()
    
    //自定义构造函数
    init(frame: CGRect , titles: [String]) {
        
        self.titles = titles;
        
        super.init(frame:frame);
        
        //设置ui界面
        
        setupUI();
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView {

    fileprivate func setupUI() {
        
        //添加scrollview
        addSubview(scrollView)
        
        scrollView.frame = bounds;
        
        //添加Titel对应label
        
        setupTitleLabels();
        
        //设置滚动滑块和底线
        
        setupBottomMenuAndScrollLine();
        
    }
    
    fileprivate func setupTitleLabels() {
        
        let labelW :CGFloat = frame.width/CGFloat(titles.count);
        
        let labelH :CGFloat = frame.height - kScrollLineH;
        
        let labelY :CGFloat = 0;
        
        for (index,title) in titles.enumerated() {
            
            //创建label
            let label = UILabel();
            
            //设置属性
            label.text = title;
            
            label.tag = index;
            
            label.font = UIFont.systemFont(ofSize: 16.0);
            
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2);
            
            label.textAlignment = .center;
            
            //设置farm
            let labelX :CGFloat = labelW * CGFloat(index);
        
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH);
            
            //将label添加到scrollView中
            scrollView.addSubview(label);
            
            titleLabels.append(label);
            
            //给label 添加手势
            label.isUserInteractionEnabled = true;
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGws:)));
            
            label.addGestureRecognizer(tapGes);
            
            
            
        }
    
    }
    

    
    fileprivate func setupBottomMenuAndScrollLine() {
    
        //添加线
        let lineView = UIView();
        
        lineView.backgroundColor = UIColor.lightGray;
        
        let lineH :CGFloat = 0.5;
        
        lineView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: lineH);
        
        addSubview(lineView);
        
        //获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2);
        
        scrollView.addSubview(scrollLine);
        
        scrollLine.frame = CGRect (x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH , width: firstLabel.frame.width, height: kScrollLineH);
        
        
    }

}

extension PageTitleView {
    //事件监听需要加objc
    @objc fileprivate func titleLabelClick(tapGws : UITapGestureRecognizer){
    
        //获取当前label下标
        guard let currentLabel = tapGws.view as? UILabel else{return};
        
        //获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2);
        
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2);
        
        //保存最新label下标
        currentIndex = currentLabel.tag;
        
        //滚动条位置改变
        let scrollLineX = CGFloat (currentLabel.tag) * scrollLine.frame.width
        
        UIView.animate(withDuration: 0.15) {
            
            self.scrollLine.frame.origin.x = scrollLineX;
        }
        
        deleate?.pageTitleView(titleView: self, selectedIndex: currentIndex);
    }

}
//对外暴露的方法
extension PageTitleView {

    func setTitleWithProgress(progress :CGFloat ,sourceIndex :Int,targetIndex :Int)  {
        
        //获取label
        let sourceLabel = titleLabels[sourceIndex];
        
        let targetLabel = titleLabels[targetIndex];
        
        //处理滑块逻辑
        let moveTotaX =  targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        
        let moveX = moveTotaX * progress;
        
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX;
        
        //颜色渐变
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2);
        
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress);
        
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress);
        
        //记录最近index
        currentIndex = targetIndex ;
    }
    
}
