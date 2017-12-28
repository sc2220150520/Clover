# LDNetworking

[![CI Status](http://img.shields.io/travis/xuguoxing/LDCPNetworking.svg?style=flat)](https://travis-ci.org/xuguoxing/LDCPNetworking)
[![Version](https://img.shields.io/cocoapods/v/LDCPNetworking.svg?style=flat)](http://cocoadocs.org/docsets/LDCPNetworking)
[![License](https://img.shields.io/cocoapods/l/LDCPNetworking.svg?style=flat)](http://cocoadocs.org/docsets/LDCPNetworking)
[![Platform](https://img.shields.io/cocoapods/p/LDCPNetworking.svg?style=flat)](http://cocoadocs.org/docsets/LDCPNetworking)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

LDNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "LDNetworking"

## Version

* 0.0.1

    1. 网络基础库，基于AFNetworking AFSessionManager封装，提供SSL验证、并发请求、自定义Post数据加密； 
    2. 提供基本的分布式接口，可以在分布式接口基础上定制集成式接口，参考代码中的注视部分；分布式接口将更加有利于个性化接口的定义，对于普通无定制的接口采用集成式接口更加方便； 
    3. 抽象提供给上层的接口跟AFNetworking无关，方便切换


## Example

#### 启动配置

```
/**
     * 在应用冷启动阶段统一设置interfaceHeader、userAgent、sslHosts；
     * 并且设置加密Post请求的默认加密方法；如果需要设置自定义加密，调用@selector(configCustomPostRequestEncryptBlock:)
     */
     
    NSSet *sslHosts = [NSSet setWithArray:@[@"api.caipiao.163.com"]];
    [LDAPIManager sharedAPIManager].configuration.interfaceHeader = [self getInterfaceHeader];
    [LDAPIManager sharedAPIManager].configuration.userAgent = [self userAgent];
    [LDAPIManager sharedAPIManager].configuration.sslHosts = sslHosts;
    
    //设置默认的加密block
    [LDAPIManager sharedAPIManager].configuration.apiEncyptPostRequestBlock = ^(NSData *postBody, NSString *timeStamp){
        return postBody;
    };
```


#### 分布式接口

```
	/**
     * 而对于一些特殊定制的接口，则可以使用分布式接口，分布式接口有两种实用方式；
     * 目前可以特殊定制的选项参看LDBaseAPI和LDGeneralAPI两个类
     * (1) 类扩展方式: 继承LDBaseAPI, 分别重载各个需要自定义的<参数方法>
     * (2) 通用类方式: 实例化LDGeneralAPI, 分别设置各个需要自定义的<参数属性>
     */
    
    //Example1: 类扩展方式，API太多容易类爆炸
    CPRefreshPeriodAPI *refreshAPI2 = [[CPRefreshPeriodAPI alloc] init];
    [refreshAPI2 setApiCompletionHandler:completionHandler];
	[refreshAPI2 start];
    
    //Example2: 通用类方式，有效防止类爆炸，如果个性化设置项太多，代码行数较多
    LDGeneralAPI *grefreshAPI = [[LDGeneralAPI alloc] init];
    grefreshAPI.apiRequestUrl = [NSString stringWithFormat:@"%@?&ifCurrent=1&totalStatusSupport=1&url=3", @"http://api.caipiao.163.com/period.html"];
    grefreshAPI.apiRequestTimeoutInterval = 60;
    grefreshAPI.apiCompletionHandler = completionHandler;
	[grefreshAPI start];
```

#### 批量请求接口

```
	/**
     * 对于需要批量发送的请求，可以使用LDBatchAPI
     * 可以选择单次添加，也可以选择批量添加
     */
     
    LDBatchAPI *batchAPI = [[LDBatchAPI alloc] init];
    [batchAPI addAPI:refreshAPI1];
    [batchAPI addBatchAPIs:[NSSet setWithArray:@[grefreshAPI]]];
    batchAPI.batchAPIFinishedBlock = ^(LDBatchAPI *batchAPI){
        NSLog(@"所有请求发送完毕");
    };
    [batchAPI start];
```



## Author

philon, huipang@corp.netease.com

## License

LDNetworking is available under the MIT license. See the LICENSE file for more info.


## Dependency

	pod 'AFNetworking', '~> 3.1.0'
