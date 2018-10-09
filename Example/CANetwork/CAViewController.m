//
//  CAViewController.m
//  CANetwork
//
//  Created by ash on 10/09/2018.
//  Copyright (c) 2018 aichiko66@163.com. All rights reserved.
//

#import "CAViewController.h"
#import <CANetwork/CANetwork.h>

@interface CAViewController ()

@end

@implementation CAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [CCNetworkConfig sharedConfig].debugLogEnabled = YES;
    
    CCCacheRequest *request = [[CCCacheRequest alloc] init];
    request.requestUrl = @"http://115.231.9.195:8099/api/GetVersionNo?os=ios";
    
    //    [[CCNetworkAgent sharedAgent] addRequest:request];
    [request startWithCompletionBlockWithSuccess:^(__kindof CCBaseRequest * _Nonnull request) {
        NSLog(@"%@", request);
    } failure:^(__kindof CCBaseRequest * _Nonnull request) {
        NSLog(@"%@", request);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
