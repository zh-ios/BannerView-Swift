//
//  ImageLoadExt.swift
//  YouthHelp
//
//  Created by ZGTX on 2016/11/18.
//  Copyright © 2016年 ZGTX. All rights reserved.
//  图片加载扩展

import UIKit

typealias completionHandler = (UIImage?, Error?, URL?) -> Void

extension UIImageView {
    func setImageWithUrl(_ url: String,_ placeholder: String?) {
        var placeholderImg: UIImage?
        if placeholder == nil {
            placeholderImg = nil
        } else {
            placeholderImg = UIImage.init(named: placeholder!)
        }
        self.sd_setImage(with: URL.init(string: url), placeholderImage: placeholderImg)
    }
    
    func setImageWithUrl(_ url: String) {
        self.sd_setImage(with: URL.init(string: url))
    }
    
    // use this
    func setImageWithUrl(_ url: String,_ placeholder: String?,completionHandler: @escaping completionHandler) -> Void {
        var placeholderImg: UIImage?
        if placeholder == nil {
            placeholderImg = nil
        } else {
            placeholderImg = UIImage.init(named: placeholder!)
        }
        
        self.sd_setImage(with: URL.init(string: url), placeholderImage: placeholderImg, options: SDWebImageOptions.retryFailed, progress: {
            (_,_,_) in
            
        }, completed: {
            (image,error,_,imgUrl) in
            completionHandler(image,error,imgUrl)
        })
    }
}
