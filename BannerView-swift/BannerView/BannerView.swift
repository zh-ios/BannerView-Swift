//
//  BannerView.swift
//
//
//  Created by zh on 2016/11/24.
//  Copyright © 2016年 zh. All rights reserved.


//            [url1,url2,url3,url4]  （url 数组）
//                     ||
//        [url4  url1  url2  url3  url4  url1]  （cell 对应的url）
//              *起始位------------------->滚动到最后一个cell时--|
//                   <---------------------------------------|
//                   (回到起始位置)
//        向左滚动时原理同向右滚动

import Foundation
import UIKit

private let cellID = "bannerCell"

enum ScrollMode: Int {
    case horizontal = 0
    case vertical
}

class BannerView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    var placeholder: String?
    var duration = 5.0
    var imgArr: [String]? {
        didSet {
            guard (self.imgArr?.count)! > 1 else {
                self.collectionView.isScrollEnabled = false
                return
            }
            scrollTo(crtPage: 0 + 1 , animated: false)
            if self.isAutoScroll == true {
                addTimer()
            }
            self.pageControl.numberOfPages = (self.imgArr?.count)!
            self.collectionView.reloadData()
        }
    }
    var mode: ScrollMode = .horizontal {
        didSet {
            if mode == .horizontal {
                self.layout.scrollDirection = .horizontal
            } else {
                self.layout.scrollDirection = .vertical
                self.pageControl.removeFromSuperview()
            }
            self.collectionView.setCollectionViewLayout(self.layout, animated: true)
        }
    }
    var isAutoScroll = false
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var timer: Timer?
    // 懒加载layout
    lazy fileprivate var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.itemSize = CGSize.init(width: self.frame.size.width, height: self.frame.size.height)
        layout.minimumLineSpacing = 0
        return layout
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupCollectionView()
        setupPageControl()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview != nil else {
            return
        }
        super.willMove(toSuperview: newSuperview)
        // 如果imgArr 为 nil return
        if self.imgArr == nil {
            return
        }
        guard (self.imgArr?.count)! > 1 else {
            self.collectionView.isScrollEnabled = false
            return
        }
        scrollTo(crtPage: 0 + 1 , animated: false)
        if self.isAutoScroll == true {
            addTimer()
        }
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: self.layout)
        self.collectionView.bounces = false
        self.collectionView.register(BannerCollectionCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
    }
    
    fileprivate func setupPageControl() {
        self.pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 22, width: self.frame.size.width, height: 22))
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.contentHorizontalAlignment = .center
        self.addSubview(self.pageControl)
        // 注意：下面这两个属性有冲突（hidesForSinglePage优先级比较高），当设置了 hidesForSinglePage = true 时，如果不止有一页那么再设置 isHidden = true 没有卵用！！！。反之，如果不设置这个属性则可以通过 isHidden 这个属性控制pageControll的显示和隐藏。
        self.pageControl.hidesForSinglePage = true
//        self.pageControl.isHidden = true
    }
    
    fileprivate func addTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: self.duration, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    fileprivate func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc fileprivate func nextPage() {
        if (self.imgArr?.count)! > 1 {
            var crtPage = 0
            if self.mode == .horizontal {
                crtPage = lroundf(Float(self.collectionView.contentOffset.x/self.frame.size.width))
            } else {
                crtPage = lroundf(Float(self.collectionView.contentOffset.y/self.frame.size.height))
            }
            scrollTo(crtPage: crtPage + 1, animated: true)
        }
    }
  
    fileprivate func scrollTo(crtPage: Int, animated: Bool) {
        if self.mode == .horizontal {
            self.collectionView.setContentOffset(CGPoint.init(x: self.frame.size.width * CGFloat(crtPage), y: 0), animated: animated)
        } else {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: self.frame.size.height * CGFloat(crtPage)), animated: animated)
        }
    }

    // collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.imgArr?.count)! > 1 {
           return (self.imgArr?.count)! + 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BannerCollectionCell
        cell.placeholder = self.placeholder
        if indexPath.row == 0 {
            cell.imgUrl = self.imgArr?.last
        } else if indexPath.row == (self.imgArr?.count)! + 1 {
            cell.imgUrl = self.imgArr?.first
        } else {
            cell.imgUrl = self.imgArr?[indexPath.row - 1]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = (self.imgArr?.count)! > 1 ? (indexPath.item - 1) : 0
        print("------>\(row)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = CGFloat(0)
        if self.mode == .horizontal {
            offset = scrollView.contentOffset.x
        } else {
            offset = scrollView.contentOffset.y
        }
        
        let x = self.mode == .horizontal ? self.frame.size.width : self.frame.size.height
        
        if offset == 0 {
            scrollTo(crtPage: (self.imgArr?.count)!, animated: false)
            self.pageControl.currentPage = (self.imgArr?.count)! - 1
        } else if offset == CGFloat((self.imgArr?.count)! + 1) * x {
            scrollTo(crtPage: 1, animated: false)
            self.pageControl.currentPage = 0
        } else {
           self.pageControl.currentPage = lroundf(Float(offset/self.frame.size.width)) - 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // pause
        self.timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // resume
        self.timer?.fireDate = Date.init(timeIntervalSinceNow: self.duration)
    }
}


///// cell
class BannerCollectionCell: UICollectionViewCell {
    var placeholder: String?
    var imgView: UIImageView!
    var imgUrl: String! {
        get {
            return self.imgUrl
        }
        set {
            imgView.setImageWithUrl(newValue, self.placeholder)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupContent()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupContent() {
        self.imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.contentView.addSubview(imgView)
        self.imgView.contentMode = .scaleAspectFill
        self.imgView.clipsToBounds = true
    }
}
