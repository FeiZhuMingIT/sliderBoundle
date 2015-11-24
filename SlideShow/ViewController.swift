//
//  ViewController.swift
//  SlideShow
//
//  Created by zhangping on 15/11/17.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var prePoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInView(view)
        
        // 记录上一个点
        prePoint = point
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first

        // 获取当前的触摸点
        let point = touch?.locationInView(view)
        print("dd");
        // 如果有上一个点
        if let pPoint = prePoint {
            
            // 计算x方向的拖动距离
            let delta = point!.x - pPoint.x
            
            // 判断是从右往左,还是从左往右 delta < 0表示往左边拖动
            if delta < 0 && coverView.frame.origin.x > 0 {
                // 如果此时 origin.x > 0 先让 origin.x = 0
                coverView.frame.origin.x += delta
                
                // 当 coverView.frame.o  rigin.x 不能小于0
                if coverView.frame.origin.x < 0 {
                    coverView.frame.origin.x = 0
                }
            } else {
                // 设置 frame
                coverView.frame.size.width += delta
            }
            
            // 当 coverView.frame.size.width 大于屏幕宽度的时候,让它等于屏幕宽度,移动origin.x
            if coverView.frame.size.width > view.frame.width {
                let d = coverView.frame.size.width - view.frame.width
                coverView.frame.size.width = view.frame.width
                
                // 移动origin.x
                coverView.frame.origin.x += d
            }
        }
        
        // 设置当前点为上一个点
        prePoint = point
        
        // 判断显示上一张图片还是下一张图片
        if coverView.frame.origin.x > 0 {
            // 显示上一张
            bkgView.image = UIImage(named: "4.png")
            
            // 移动背景view的origin.x
            bkgView.frame.origin.x = -view.frame.width * 0.5 + coverView.frame.origin.x * 0.5
        } else if coverView.frame.width < view.frame.width {
            // 显示下一张
            bkgView.image = UIImage(named: "3.png")
            // 移动背景view的origin.x
            bkgView.frame.origin.x = view.frame.width * 0.5 - (view.frame.width - coverView.frame.width) * 0.5
        }
    }
    
    /// 移动结束的时候
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 判断fram.width 是否小于屏幕的宽度,小于就做动画回去
        if coverView.frame.width < view.frame.width {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.coverView.frame.size.width = self.view.frame.width
            })
        }
        
        // 判断 origin.x是否大于0,大于0就动画回去
        if coverView.frame.origin.x > 0 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.coverView.frame.origin.x = 0
            })
        }
    }
    
    /// 设置frame和添加子控件
    private func prepareUI() {
        bkgView.frame = view.bounds
        
        view.addSubview(bkgView)
        
        coverView.frame = view.bounds
        
        view.addSubview(coverView)
    }
    
    /// 包裹前面的view
    private lazy var coverView: UIView = {
        let view = UIView()
        
        self.fView.frame = self.view.bounds
        
        view.addSubview(self.fView)
        
        view.clipsToBounds = true
        
        return view
    }()
    
    /// 前面的view,可以拖拽的view
    private lazy var fView: UIImageView = {
        let imageView = UIImageView()
       
        imageView.image = UIImage(named: "2.png")
        
        return imageView
    }()
    
    /// 后面的view.用来显示上一张或下一张
    private lazy var bkgView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "3.png")
        
        return imageView
    }()
}

