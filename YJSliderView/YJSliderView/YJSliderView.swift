//
//  YJSliderView.swift
//  YJSliderView
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 Leo. All rights reserved.
//

protocol YJSliderViewDelegate {
    func ShowLRNumber(leftNum:String,rightNum:String)
}

import UIKit
import SnapKit

class YJSliderView: UIView {

    var delegate : YJSliderViewDelegate!
    
    //数值显示
    var lbLeftPrice = UILabel()
    var lbRightPrice = UILabel()
    //刻度图
    lazy var priceBg = UIImageView()
    //蓝色进度条
    lazy var progressView = UIView()
    //左把手
    lazy var leftHandImageView = UIImageView()
    //右把手
    lazy var rightHandImageView = UIImageView()
    
    var leftValue : Float?
    var rightValue : Float?
    
    
    //以下四个变量直接决定：左右初始值，左右最大差值，左右最小差值 （使用的时候设置两个初始值即可）
    //初始值
    var oldLeftValue = 0{
        didSet{
            leftValue = Float.init(oldLeftValue)
            rightValue = Float.init(oldRightValue)
            
            differentValue = oldRightValue - oldLeftValue
            
            minDifferentValue = differentValue / 100
            self.updateData()
        }
    }
    var oldRightValue = 100{
        didSet{
            leftValue = Float.init(oldLeftValue)
            rightValue = Float.init(oldRightValue)
            
            differentValue = oldRightValue - oldLeftValue
            
            minDifferentValue = differentValue / 100
            self.updateData()
        }
    }
    
    //左右最大差值
    var differentValue = 0
    
    //两边最小差值
    var minDifferentValue = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //自定义初始化方法
    //    init(frame: CGRect,startLeft:Int,startRight:Int) {
    //        super.init(frame: frame)
    //
    //        oldLeftValue = startLeft
    //        oldRightValue = startRight
    //
    //        leftValue = Float.init(oldLeftValue)
    //        rightValue = Float.init(oldRightValue)
    //
    //        differentValue = oldRightValue - oldLeftValue
    //
    //        minDifferentValue = differentValue / 100
    //
    //        self.initUI()
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftValue = Float.init(oldLeftValue)
        rightValue = Float.init(oldRightValue)
        
        differentValue = oldRightValue - oldLeftValue
        
        minDifferentValue = differentValue / 100
        
        self.initUI()
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func initUI() {
        
        //刻度图
        priceBg = UIImageView.init(frame: CGRect.init(x: 2 * kBasePadding, y: self.frame.maxY / 2, width: kScreenWidth - 4 * kBasePadding, height: scaleFromiPhone6DesinWidth(x: 4)))
        
        priceBg.image = self.createImage(kMainGrayColor!)
        priceBg.layer.cornerRadius = 4
        self.addSubview(priceBg)
        
        //蓝色进度条
        progressView.backgroundColor = kMainColor
        progressView.layer.cornerRadius = 4
        self.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(priceBg.snp.left)
            make.bottom.equalTo(priceBg.snp.bottom)
            make.right.equalTo(priceBg.snp.right)
            make.height.equalTo(scaleFromiPhone6DesinWidth(x: 4))
        }
        //左把手
        leftHandImageView.image = self.createImage(kWhiteColor)
        
        //
        let leftPanRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.leftHandMove(pan:)))
        leftPanRecognizer.minimumNumberOfTouches = 1
        leftPanRecognizer.maximumNumberOfTouches = 1
        leftHandImageView.isUserInteractionEnabled = true
        leftHandImageView.addGestureRecognizer(leftPanRecognizer)
        leftHandImageView.clipsToBounds = true
        leftHandImageView.layer.cornerRadius = scaleFromiPhone6DesinWidth(x: 10)
        leftHandImageView.layer.borderWidth = 1
        leftHandImageView.layer.borderColor = kMainColor?.cgColor
        self.addSubview(leftHandImageView)
        leftHandImageView.snp.makeConstraints { (make) in
            make.left.equalTo(2 * kBasePadding - scaleFromiPhone6DesinWidth(x: 10))
            make.centerY.equalTo(priceBg.snp.centerY)
            make.width.equalTo(scaleFromiPhone6DesinWidth(x: 20))
            make.height.equalTo(scaleFromiPhone6DesinWidth(x: 20))
        }
        
        //右把手
        rightHandImageView.image = self.createImage(kWhiteColor)
        //
        let rightPanRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.rightHandMove(pan:)))
        rightHandImageView.isUserInteractionEnabled = true
        rightHandImageView.addGestureRecognizer(rightPanRecognizer)
        rightHandImageView.clipsToBounds = true
        rightHandImageView.layer.cornerRadius = scaleFromiPhone6DesinWidth(x: 10)
        rightHandImageView.layer.borderWidth = 1
        rightHandImageView.layer.borderColor = kMainColor?.cgColor
        self.addSubview(rightHandImageView)
        rightHandImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-(2 * kBasePadding - scaleFromiPhone6DesinWidth(x: 10)))
            make.centerY.equalTo(priceBg.snp.centerY)
            make.width.equalTo(scaleFromiPhone6DesinWidth(x: 20))
            make.height.equalTo(scaleFromiPhone6DesinWidth(x: 20))
        }
        
        //数值显示
        lbLeftPrice = UILabel.init(frame: CGRect.init(x: kBasePadding, y: priceBg.frame.maxY + scaleFromiPhone6DesinWidth(x: 24), width: scaleFromiPhone6DesinWidth(x: 100), height: scaleFromiPhone6DesinWidth(x: 10)))
        lbLeftPrice.text = "当前价格"
        lbLeftPrice.textAlignment = .left
        lbLeftPrice.font = kFontWithSize(10)
        lbLeftPrice.textColor = k9Color
        self.addSubview(lbLeftPrice)
        
        lbRightPrice = UILabel.init(frame: CGRect.init(x: kScreenWidth - kBasePadding - scaleFromiPhone6DesinWidth(x: 100), y: priceBg.frame.maxY + scaleFromiPhone6DesinWidth(x: 24), width: scaleFromiPhone6DesinWidth(x: 100), height: scaleFromiPhone6DesinWidth(x: 10)))
        lbRightPrice.text = "当前价格"
        lbRightPrice.textAlignment = .right
        lbRightPrice.font = kFontWithSize(10)
        lbRightPrice.textColor = k9Color
        self.addSubview(lbRightPrice)
        
        
        self.updateData()
        
    }
    
    //响应用户手势
    //左
    @objc func leftHandMove(pan:UIPanGestureRecognizer) {
        let point = pan.translation(in: leftHandImageView)
        var x : CGFloat = leftHandImageView.center.x + point.x
        
        if(x > (self.priceBg.bounds.maxX + 2 * kBasePadding - (self.priceBg.bounds.maxX / CGFloat.init(differentValue) * CGFloat.init(minDifferentValue)))){
            x = self.priceBg.bounds.maxX + 2 * kBasePadding - (self.priceBg.bounds.maxX / CGFloat.init(differentValue) * CGFloat.init(minDifferentValue))
        }else if (x <= 2 * kBasePadding ){
            x = 2 * kBasePadding
        }
        
        leftValue = ceil(self.x2price(x: CGFloat(x)))
        leftHandImageView.center = CGPoint.init(x: CGFloat.init(ceil(x)), y: leftHandImageView.center.y)
        
        if (rightValue! - leftValue!) <= Float.init(minDifferentValue){
            rightValue = leftValue! + Float.init(minDifferentValue)
            rightHandImageView.center = CGPoint.init(x: ceil(self.price2x(price: CGFloat.init(rightValue!))), y: rightHandImageView.center.y)
        }
        
        pan.setTranslation(CGPoint.init(x: 0, y: 0), in: self)
        self.updateData()
    }
    //右
    @objc func rightHandMove(pan:UIPanGestureRecognizer) {
        let point = pan.translation(in: rightHandImageView)
        var x : CGFloat = rightHandImageView.center.x + point.x
        
        if(x > (self.priceBg.bounds.maxX + 2 * kBasePadding)){
            x = (self.priceBg.bounds.maxX + 2 * kBasePadding)
        }else if (x <= 2 * kBasePadding + (self.priceBg.bounds.maxX / CGFloat.init(differentValue) * CGFloat.init(minDifferentValue))){
            x = 2 * kBasePadding + (self.priceBg.bounds.maxX / CGFloat.init(differentValue) * CGFloat.init(minDifferentValue))
        }
        
        rightValue = ceil(self.x2price(x: CGFloat(x)))
        
        rightHandImageView.center = CGPoint.init(x: CGFloat.init(ceil(x)), y: rightHandImageView.center.y)
        
        if (rightValue! - leftValue!) <= Float.init(minDifferentValue){
            leftValue = rightValue! - Float.init(minDifferentValue)
            leftHandImageView.center = CGPoint.init(x: ceil(self.price2x(price: CGFloat.init(leftValue!))), y: leftHandImageView.center.y)
        }
        
        
        pan.setTranslation(CGPoint.zero, in: self)
        self.updateData()
    }
    
    //更新数值和进度条
    func updateData() {
        lbLeftPrice.text = "\((Int)(leftValue!))"
        lbRightPrice.text = "\((Int)(rightValue!))"
        let progressRect = CGRect.init(x: leftHandImageView.center.x, y: progressView.frame.origin.y, width: rightHandImageView.center.x - leftHandImageView.center.x, height: progressView.frame.size.height)
        
        progressView.frame = progressRect
        
        if nil != delegate{
            delegate.ShowLRNumber(leftNum: lbLeftPrice.text!, rightNum: lbRightPrice.text!)
        }
    }
    
    //坐标->价格
    
    func x2price(x: CGFloat) -> Float {
        var price: CGFloat = 0.0
        if x == 2 * kBasePadding{
            price = CGFloat(self.oldLeftValue)
        }else if x < self.priceBg.bounds.maxX + 2 * kBasePadding{
            price = (x - 2 * kBasePadding) * (CGFloat.init(differentValue) / self.priceBg.bounds.maxX) + CGFloat.init(oldLeftValue)
        }else{
            price = CGFloat(oldRightValue)
        }
        
        return Float.init(price)
    }
    
    //价格->坐标
    
    func price2x(price: CGFloat) -> CGFloat {
        var x: CGFloat = 0.0
        if price == CGFloat(self.oldLeftValue) {
            x = 2 * kBasePadding
        }else if price > CGFloat(self.oldLeftValue) && price < CGFloat(self.oldRightValue){
            x = (price - CGFloat.init(self.oldLeftValue)) / (CGFloat(self.differentValue) / self.priceBg.bounds.maxX) + 2 * kBasePadding
        }else{
            x = self.priceBg.bounds.maxX + 2 * kBasePadding
        }
        return x
    }
    
    //颜色生成图片
    func createImage(_ color: UIColor)-> UIImage{
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

