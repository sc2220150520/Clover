# MKAdditions

[![CI Status](http://img.shields.io/travis/fanxuejiao/MKAdditions.svg?style=flat)](https://travis-ci.org/fanxuejiao/MKAdditions)
[![Version](https://img.shields.io/cocoapods/v/MKAdditions.svg?style=flat)](http://cocoapods.org/pods/MKAdditions)
[![License](https://img.shields.io/cocoapods/l/MKAdditions.svg?style=flat)](http://cocoapods.org/pods/MKAdditions)
[![Platform](https://img.shields.io/cocoapods/p/MKAdditions.svg?style=flat)](http://cocoapods.org/pods/MKAdditions)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MKAdditions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

## Version

* 0.1.4

    修复9.x系统上UIAlertController的tintColor问题

* 0.1.3
    
    bundle指向空文件导致XCode8.1 code sign failed，修改Spec文件和删除Assets文件

* 0.1.2
    
    支持7.0以上、ios8以上使用UIAlertController替代、UIAlertView、实现优化（ARC、关联变量代替静态变量）

* 0.1.1
    
    支持6.0及以上

* 0.1.0
  
    新建pod内容：1、NSObject+MKBlockAdditions sends a block message to the receiver 
               2、UIActionSheet+MKBlockAdditions define the action sheet with dismissBlock、cancelBlock,and photo Picker function
               3、UIAlertView+MKBlockAdditions define the alert view with dismissBlock and cancelBlock

## Author

fanxuejiao, fanxuejiao@corp.netease.com

## License

MKAdditions is available under the MIT license. See the LICENSE file for more info.
