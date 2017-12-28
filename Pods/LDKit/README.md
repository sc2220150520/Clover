# LDKit

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LDKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


## Version
* 0.0.1  
    1.目前包含项目中使用category及新版弹窗
* 0.0.2  
    1.UIButtonCategory问题修复
* 0.0.3  
    1.修复hook方法未加前缀问题
* 0.0.4  
    1.修复LDKit.h暴露头文件错误的问题  
    2.添加弹窗样式  
    3.添加button样式  
* 0.1.0  
    1.Spec暴露两个主要.h文件  
    2.Fix Custom圆角半径设得较大时的异常显示  
    3.移除NSDictionary+LDAddition/NSArray+LDSafe扩展  
    4.消除警告
* 0.1.1  
    1.UIButton+LDCustom添加新Style  
    2.UIColor添加按比例取中间颜色方法  
    3.UIImage添加修改alpha方法
* 0.2.0  
    1.添加LDKeychain  
    2.添加CPFoundationCategory、LDCPCommon、LDCPViewControllerToast、LDZBKit中内容  
    3.添加UIScreen+LDAddition扩展
* 0.2.1  
    1.修正UIViewController+LDToast中indicator位置异常  
    2.LDLightAlert添加指定point与superView参数的接口
* 0.2.2  
    1.调整Toast提示信息的显示位置 使之屏幕居中  
* 0.2.3  
    1.添加UIFont扩展 便于设置项目默认字体  
* 0.2.4  
    1.调整视觉规范弹窗字体为项目默认字体
* 0.2.5  
    1.调整目录结构采用subspec
    2.增加部分方法
* 0.2.6
	1. UIView添加扩展，便于读写frame，及删除所有子视图
	2. NSString添加数字串的千分位表示法
	3. NSString添加对IP地址的判断方法
	4. UIDevice补充新设备信息
* 0.2.7
    1. 修改ld_toastWithError，直接弹error的LocalizedDesc，不做特殊处理

* 0.2.8
    忽略
    
* 0.2.9
    工程demo使用pod管理； 修复iOS11上UINavigationItem的适配问题
    
    
## Author

lxd, bjlixingdong@corp.netease.com
fxj, fanxuejiao@corp.netease.com

## License

LDKit is available under the MIT license. See the LICENSE file for more info.

#### 已完成文件列表
# NSDate+Additions

# NSData+Crypto

# NSString+Draw
# NSString+Additions
# NSString+CPCircleStringUtils
# NSString+NLDAddition
# NSString+isEmpty

# UIButton+Arrow
# UIButton+AllState
# UIButton+HitEdgeInsets

# UIColor+Hex
# UIColor+Utility
# UIColor+LDUtility

# UIImage+Alpha
# UIImage+ImageHelper
# UIImage+Tint
# UIImage+Resize
# UIImage+RoundedCorner
# UIImage+RetinaSize
# UIImage+LDSDKShare
# UIImage+Acitivity
# UIImage+animatedGIF

# UINib+Simple

# UITextField+Selection

# NSMutableArray+Safe
# NSMutableArray+String

# NSMutableSet+EqualSet.h
# NSMutableSet+AwardConfigEqualSet.h

# NSArray+Safe

# NSMutableDictionary+Safe

# NSDictionary+Accessors
# NSDictionaryAdditions

# NSTimer+BreakRetainLoop

# UIDevice+Hardware
# UIDevice+LDHardware

# UIScrollView+ContentExtension
# UIScrollView+contentOffset

# UIViewController+IsMainTab
# UIViewController+NavModalStyle
# UIViewController+TopmostViewController
# UIViewController+LDUtilities

# UIView+Frame
# UIView+CustomFrame
# UIView+LDCPAutoLayoutHelper
# UIView+Hierarchy
# UIView+CustomNavBar

# UITableViewCell+SeparatorLine  (hooked layoutSubviews)
# UICollectionReusableView+SeparatorLine

# NSAttributedString+isEmpty

# NSJSONSerialization+Simple
# UICollectionViewCell+SeparatorLine


