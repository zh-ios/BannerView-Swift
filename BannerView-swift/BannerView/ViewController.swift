//
//  ViewController.swift
//  BannerView
//
//  Created by autohome on 16/12/22.
//  Copyright © 2016年 autohome. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let banner = BannerView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        // 在加到父视图之前设置属性 ！！！
        banner.isAutoScroll = true
//        banner.mode = .vertical
        
        self.view.addSubview(banner)
       banner.isHidePageControl = true
        banner.imgArr = [
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-4.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-5.jpg"]
        
        let banner2 = BannerView.init(frame: CGRect.init(x: 0, y: 300, width: self.view.frame.size.width, height: 200))
        banner2.imgArr = [
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-4.jpg",
            "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-5.jpg"]
        
        banner2.isAutoScroll = true
        banner2.mode = .vertical
        banner2.duration = 5
        self.view.addSubview(banner2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

}

