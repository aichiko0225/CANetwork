//
//  CCNetworkConfig.m
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import "CCNetworkConfig.h"
#import "CCBaseRequest.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation CCNetworkConfig
{
    NSMutableArray<id<CCUrlFilterProtocol>> *_urlFilters;
    NSMutableArray<id<CCCacheDirPathFilterProtocol>> *_cacheDirPathFilters;
}

+ (CCNetworkConfig *)sharedConfig {
    static CCNetworkConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrl = @"";
        _cdnUrl = @"";
        _timeoutInterval = 20;
        _urlFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _debugLogEnabled = NO;
    }
    return self;
}

- (NSTimeInterval)timeoutInterval {
    return _timeoutInterval;
}

- (NSString*)baseUrl {
    return _baseUrl;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (void)addUrlFilter:(id<CCUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

- (void)clearUrlFilter {
    [_urlFilters removeAllObjects];
}

- (void)addCacheDirPathFilter:(id<CCCacheDirPathFilterProtocol>)filter {
    [_cacheDirPathFilters addObject:filter];
}

- (void)clearCacheDirPathFilter {
    [_cacheDirPathFilters removeAllObjects];
}

- (NSArray<id<CCUrlFilterProtocol>> *)urlFilters {
    return [_urlFilters copy];
}

- (NSArray<id<CCCacheDirPathFilterProtocol>> *)cacheDirPathFilters {
    return [_cacheDirPathFilters copy];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ baseURL: %@ } { cdnURL: %@ }", NSStringFromClass([self class]), self, self.baseUrl, self.cdnUrl];
}


@end
