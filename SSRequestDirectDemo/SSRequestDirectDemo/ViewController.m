//
//  ViewController.m
//  SSRequestDirect
//
//  Created by ixiazer on 2020/3/17.
//  Copyright © 2020 FF. All rights reserved.
//

#import "ViewController.h"
#import "FFHomeApi.h"
#import "FFHomePostApi.h"
#import "NSString+FFHome.h"
#import "SSRequestHandler.h"
#import <SSRequestDirectDemo-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    NSLog(@"ViewController did launch");
    
    [SSRequestSettingConfig defaultSettingConfig].appId = @"100001";
    [SSRequestSettingConfig defaultSettingConfig].deviceId = @"mnsdnjenrjkjke38dajdjwejd";
    [SSRequestSettingConfig defaultSettingConfig].token = @"dskjjjjdj3dsjs";
    [SSRequestSettingConfig defaultSettingConfig].secret = @"eiifs9wesdfsjes";
    [SSRequestSettingConfig defaultSettingConfig].plugins = @[[SSRequestTokenPlugin new], [SSRequestSignPlugin new], [SSRequestErrorFilterPlugin new]];
    [SSRequestSettingConfig defaultSettingConfig].isShowDebugInfo = true;
    [SSRequestSettingConfig defaultSettingConfig].service = [[SSRequestService alloc] initWithBaseUrl:@"https://**.******.com"];
    
    
    [self doGetRequest];
//    [self doPostRequest];
    
//    ViewControllerSwift *vc = [[ViewControllerSwift alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
}

- (void)doGetRequest {
    NSDictionary *bizContent = @{@"UserId":[NSNumber numberWithInteger:0]};
    NSDictionary *initDic = @{@"method" : @"*******",
                              @"bizContent" : [NSString jsonStringWithDictionary:bizContent],
                              @"module": @"appguide",
                              @"version": @"3.0",
                              @"clientVersion": @"6.4.2",
    };
    // OC 模式 GET Request
    FFHomeApi *homeApi = [[FFHomeApi alloc] initWithPath:@"/gateway" queries:initDic];
    __weak typeof(self) this = self;
    [homeApi requestWithCompletionBlock:^(SSResponse * _Nonnull response, NSError * _Nonnull error) {
        if (!error) {
            [this responseHandler:response];
        } else {
            // todo
        }
    }];
}

- (void)responseHandler:(SSResponse *)response {
    NSDictionary *responseDic = response.responseDic;
    NSLog(@"responseDic==>>%@", responseDic);
}

- (void)doPostRequest {
    NSDictionary *bizContent = @{@"UserId":[NSNumber numberWithInteger:7457]};
    NSDictionary *initDic = @{@"method" : @"OrderService.GetInvoiceCategories",
                              @"bizContent" : [NSString jsonStringWithDictionary:bizContent],
                              @"module": @"order",
                              @"version": @"3.0",
                              @"clientVersion": @"6.4.2",
    };
    // OC 模式 GET Request
    FFHomePostApi *homeApi = [[FFHomePostApi alloc] initWithPath:@"/gateway" queries:initDic];
    __weak typeof(self) this = self;
    [homeApi requestWithCompletionBlock:^(SSResponse * _Nonnull response, NSError * _Nonnull error) {
        // todo
        if (!error) {
            [this responseHandler:response];
        }
    }];
}

@end
