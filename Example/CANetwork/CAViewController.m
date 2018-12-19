//
//  CAViewController.m
//  CANetwork
//
//  Created by ash on 10/09/2018.
//  Copyright (c) 2018 aichiko66@163.com. All rights reserved.
//

#import "CAViewController.h"
#import <CANetwork/CANetwork.h>
#import <CANetwork/CANetwork-Swift.h>
#import <AFNetworking/AFNetworking.h>

@interface CAViewController ()
{
    UIImageView *_imageView;
}
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
//    [request startWithCompletionBlockWithSuccess:^(__kindof CCBaseRequest * _Nonnull request) {
//        NSLog(@"%@", request);
//    } failure:^(__kindof CCBaseRequest * _Nonnull request) {
//        NSLog(@"%@", request);
//    }];
    
//    CCRequest *request1 = [[CCRequest alloc] initWithBaseUrl:nil url:@"" method:CCRequestMethodGET parameters:nil cacheOption:CCRequestCacheOptionsDefault headers:nil];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
//    responseSerializer.acceptableStatusCodes = _allStatusCodes;
    manager.responseSerializer = responseSerializer;
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.62.30.205:7500/dev1/0/000/020/0000020487.fid"]] uploadProgress:nil downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSData *data = (NSData *)responseObject;
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"%@", image);
        
        _imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:_imageView];
        _imageView.center = CGPointMake(200, 300);
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
