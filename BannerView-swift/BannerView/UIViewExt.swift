//
//  UIViewExt.swift
//  YouthHelp
//
//  Created by ZGTX on 2016/11/16.
//  Copyright © 2016年 ZGTX. All rights reserved.
//  UIVIew扩展快速获取 x，y，width，height ==

import Foundation
import UIKit
extension UIView {

    func withBackgroundColor(color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    func withCornerRadius(radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func right() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }

    func bottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    func width() -> CGFloat {
        return self.frame.size.width
    }
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setX(x: CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func setRight(right: CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    
    func setY(y: CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func setBottom(bottom: CGFloat) {
        var rect:CGRect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    
    func setWidth(width: CGFloat) {
        var rect:CGRect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func setHeight(height: CGFloat) {
        var rect:CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }
}
