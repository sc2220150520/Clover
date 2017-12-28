//
//  KWAddressDatabaseService.h
//  Kiwifruit
//
//  Created by netease on 2017/9/19.
//  Copyright © 2017年 Kiwifruit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWAddressDatabaseService : NSObject

- (NSArray *)provinceIDs;
- (NSArray *)provinceNames;
- (NSArray *)cityIDsWithProvinceID:(NSString *)provinceID;
- (NSArray *)cityNamesWithProvinceID:(NSString *)provinceID;
- (NSArray *)areaIDsWithCityID:(NSString *)cityID;
- (NSArray *)areaNamesWithCityID:(NSString *)cityID;

- (NSString *)provinceNameWithID:(NSString *)provinceID;
- (NSString *)cityNameWithID:(NSString *)cityID;
- (NSString *)areaNameWithID:(NSString *)areaID;

- (NSString *)addressInfoForProvinceID:(NSString *)provinceID cityID:(NSString *)cityID areaID:(NSString *)areaID;

@end
