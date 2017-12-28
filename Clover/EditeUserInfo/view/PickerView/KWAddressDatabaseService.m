//
//  KWAddressDatabaseService.m
//  Kiwifruit
//
//  Created by netease on 2017/9/19.
//  Copyright © 2017年 Kiwifruit. All rights reserved.
//

#import "KWAddressDatabaseService.h"

#if __has_include(<sqlite3.h>)
#import <sqlite3.h>
#else
#error "Please import libsqlite3.tbd"
#endif

@implementation KWAddressDatabaseService {
    sqlite3 *areasDB;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"kiwi_areas"
                                                         ofType:@"db"];
        if (sqlite3_open([path UTF8String], &areasDB) != SQLITE_OK) {
            sqlite3_close(areasDB);
            return nil;
        }
    }
    return self;
}

- (NSArray *)provinceIDs
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = @"SELECT province_code FROM TB_KIWI_PROVINCE ORDER BY order_value asc";
    sqlite3_stmt *statement;
    //    NSLog(@"%d",sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil));
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int province_code = sqlite3_column_int(statement, 0);
            if (province_code == 810000 || province_code == 910000) {
                continue;
            }
            //NSLog(@"%d", province_code);
            [retval addObject:[NSString stringWithFormat:@"%d", province_code]];
        }
        sqlite3_finalize(statement);
    }
    
    return [retval copy];
}

- (NSArray *)provinceNames
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = @"SELECT province_name FROM TB_KIWI_PROVINCE ORDER BY order_value asc";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            if ([name isEqualToString:@"香港特别行政区"] || [name isEqualToString:@"海外"]) {
                continue;
            }
            //NSLog(@"%@", name);
            [retval addObject:name];
        }
        sqlite3_finalize(statement);
    }
    
    return [retval copy];
}

- (NSArray *)cityIDsWithProvinceID:(NSString *)provinceID
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT city_code FROM TB_KIWI_CITY WHERE `parent_code` like %@ ORDER BY order_value asc", provinceID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int city_code = sqlite3_column_int(statement, 0);
            //NSLog(@"%d", city_code);
            [retval addObject:[NSString stringWithFormat:@"%d",city_code]];
        }
        sqlite3_finalize(statement);
    }
    
    return [retval copy];
}

- (NSArray *)cityNamesWithProvinceID:(NSString *)provinceID
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT city_name FROM TB_KIWI_CITY WHERE `parent_code` like %@ ORDER BY order_value asc", provinceID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            //NSLog(@"%@", name);
            [retval addObject:name];
        }
        sqlite3_finalize(statement);
    }
    
    return [retval copy];
    
}

- (NSArray *)areaIDsWithCityID:(NSString *)cityID
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT area_code FROM TB_KIWI_AREA WHERE `parent_code` like %@ ORDER BY order_value asc", cityID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int area_code = sqlite3_column_int(statement, 0);
            //            NSLog(@"%d", area_code);
            [retval addObject:[NSString stringWithFormat:@"%d",area_code]];
        }
        sqlite3_finalize(statement);
    }
    
    return [retval copy];
}

- (NSArray *)areaNamesWithCityID:(NSString *)cityID
{
    NSMutableArray *retval = [NSMutableArray new];
    NSString *query = [NSString stringWithFormat:@"SELECT area_name FROM TB_KIWI_AREA WHERE `parent_code` like %@ ORDER BY order_value asc", cityID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            //NSLog(@"%@", name);
            [retval addObject:name];
        }
        sqlite3_finalize(statement);
    }
    return [retval copy];
}

- (NSString *)provinceNameWithID:(NSString *)provinceID
{
    NSString *provinceName = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT province_name FROM TB_KIWI_PROVINCE WHERE `province_code` like %@ ORDER BY order_value asc", provinceID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            provinceName = [[NSString alloc] initWithUTF8String:nameChars];
            //NSLog(@"%@", provinceName);
        }
        sqlite3_finalize(statement);
    }
    return provinceName.length > 0 ? provinceName : @"";
}

- (NSString *)cityNameWithID:(NSString *)cityID;
{
    NSString *cityName = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT city_name FROM TB_KIWI_CITY WHERE `city_code` like %@ ORDER BY order_value asc", cityID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            cityName = [[NSString alloc] initWithUTF8String:nameChars];
            // NSLog(@"%@", cityName);
        }
        sqlite3_finalize(statement);
    }
    return cityName.length > 0 ? cityName : @"";
    
}

- (NSString *)areaNameWithID:(NSString *)areaID;
{
    NSString *areaName = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT area_name FROM TB_KIWI_AREA WHERE `area_code` like %@ ORDER BY order_value asc", areaID];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(areasDB, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            areaName = [[NSString alloc] initWithUTF8String:nameChars];
            //NSLog(@"%@", areaName);
        }
        sqlite3_finalize(statement);
    }
    return areaName.length > 0 ? areaName : @"";
}

- (NSString *)addressInfoForProvinceID:(NSString *)provinceID cityID:(NSString *)cityID areaID:(NSString *)areaID
{
    NSString *province = [self provinceNameWithID:provinceID];
    NSString *city = [self cityNameWithID:cityID];
    NSString *area = [self areaNameWithID:areaID];
    return [NSString stringWithFormat:@"%@%@%@", province, city, area];
}
@end
