//
//  LDBatchAPI.m
//  LDNetworking
//
//  Created by philon on 16/7/22.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDBatchAPI.h"
#import "LDAPIManager.h"


@interface LDBatchAPI ()

@property (nonatomic, strong, readwrite) NSMutableSet *apiSet;

@end


@implementation LDBatchAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiSet = [NSMutableSet set];
    }
    return self;
}

- (void)addAPI:(LDBaseAPI *)api {
    NSParameterAssert(api);
    NSAssert([api isKindOfClass:[LDBaseAPI class]], @"API should be kind of LDBaseAPI");
    
    if ([self.apiSet containsObject:api]) {
#ifdef DEBUG
        NSLog(@"Add SAME API into BatchRequest set");
#endif
    }
    
    [self.apiSet addObject:api];
}

- (void)addBatchAPIs:(NSSet *)apis {
    NSParameterAssert(apis);
    NSAssert([apis count] > 0, @"Apis amounts should greater than ZERO");
    [apis enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if ([obj isKindOfClass:[LDBaseAPI class]]) {
            [self.apiSet addObject:obj];
        } else {
            __unused NSString *hintStr = [NSString stringWithFormat:@"%@ %@",
                                          [[obj class] description],
                                          @"API should be kind of LDBaseAPI"];
            NSAssert(NO, hintStr);
            return ;
        }
    }];
}

- (void)start {
    NSAssert([self.apiSet count] != 0, @"Batch API Amount can't be 0");
    [[LDAPIManager sharedAPIManager] sendBatchAPIRequests:(LDBatchAPI *)self];
}

@end
