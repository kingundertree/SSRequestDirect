//
//  FFHomeApi.m
//  SSRequstHandler
//
//  Created by ixiazer on 2020/3/12.
//  Copyright © 2020 FF. All rights reserved.
//

#import "FFHomeApi.h"

@implementation FFHomeApi

- (SSRequestService *)service {
    return [[SSRequestService alloc] initWithBaseUrl:@"https://wx.freshfresh.com"];
}

@end