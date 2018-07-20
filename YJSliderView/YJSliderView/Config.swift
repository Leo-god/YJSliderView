//
//  Config.swift
//  YJSliderView
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 Leo. All rights reserved.
//

import Foundation
import UIKit

let kBasePadding = scaleFromiPhone6DesinWidth(x: 16)


// MARK:- 屏幕尺寸适配
//根据设计图计算在手机上的真实尺寸(以6来作为标准：375 * 667)
func scaleFromiPhone6DesinWidth(x : CGFloat) -> CGFloat{
    return (x * (kScreenWidth / 375.0))
}

// MARK:- 相关尺寸
//屏幕宽高
let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = kScreenBounds.width
let kScreenHeight = kScreenBounds.height

// MARK:- 相关字体
/** 适配字体大小*/
func kFontSize(_ size:CGFloat) -> CGFloat{ // 根据不同屏幕改变字体大小
    if (kScreenWidth == 320) {
        return size - 2.0;
    }else if (kScreenWidth == 375){
        return size;
    }else{
        return size + 1.0;
    }
}
func kFontWithSize(_ size:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: kFontSize(size))
}

// MARK:- 相关颜色
//白色
let kWhiteColor = UIColor.white
let kMainColor = UIColor.init(hex: 0xf35d14)
let k9Color = UIColor.init(hex: 0x999999)
let kMainGrayColor = UIColor.init(hex: 0xeeeeee)



