//
//  CenterButtonRaisedTabBar.swift
//  CenterButtonRaisedTabBar
//
//  Created by XueMinghao on 6/6/16.
//  Copyright © 2016 XueMinghao. All rights reserved.
//

import UIKit

class CenterButtonRaisedTabBar: UITabBar {

    var centerButton: UIButton? {
        willSet {
            centerButton?.removeFromSuperview()
            
            if newValue != nil {
                addSubview(newValue!)
            }
        }
    }    
        /// 当前item数量。如果centerButton != nil，则+1
    private var itemCount: UInt {
        get {
            
            var count: UInt
            
            if items?.count == nil {
                count = 0
            } else {
                count = UInt((items?.count)!)
            }
            
            if centerButton != nil {
                count += 1
            }
            return count
        }
    }
    
        /// 是否需要为中间按钮留下额外的位置
    private var needExtraPlaceForCenterButton: Bool {
        return centerButton != nil
    }
    
        /// 中间按钮的索引
    private var centerButtonIndex: Int {
        get {
            if centerButton == nil {
                return -1
            }
            return Int(itemCount) / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        
        if itemCount == 0 {
            return
        }
        
        let _tabBarButtonClass: AnyClass? = NSClassFromString("UITabBarButton")
        guard let tabBarButtonClass = _tabBarButtonClass else {
            return //保证UITabBar的这个私有类是存在的；否则就返回
        }
        
        let width = bounds.size.width
        let height = bounds.size.height
        let itemWidth = width / CGFloat(itemCount)
        let itemHeight = height
        let itemY: CGFloat = 0
        
        var tabBarItemIndex = 0
        for aSubView in subviews{
            if aSubView.isKindOfClass(tabBarButtonClass) {
                
                if needExtraPlaceForCenterButton && tabBarItemIndex == centerButtonIndex {
                    tabBarItemIndex += 1 //为centerButton预留一个item的位置
                }
                
                let x = itemWidth * CGFloat(tabBarItemIndex)
                aSubView.frame = CGRectMake(x, itemY, itemWidth, itemHeight)
                
                tabBarItemIndex += 1
            }
        }
        
        guard let centerButton = centerButton else {
            return
        }
        centerButton.sizeToFit()
        centerButton.frame = CGRectMake(0, 0, centerButton.frame.width, centerButton.frame.height)
        centerButton.center = CGPointMake(width / 2, height / 2 + (height - centerButton.frame.height) / 2)
        bringSubviewToFront(centerButton)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, withEvent: event)
        
        if hidden {
            return view
        }
        
        if view == nil && centerButton != nil {
            
            let positionInSelf = convertPoint(point, fromView: self)
            if CGRectContainsPoint(centerButton!.frame, positionInSelf) {
                view = centerButton!
            }
        }
        return view
    }
    
}
