//
//  CCNetworkConfig.h
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CCBaseRequest;
@class AFSecurityPolicy;

///  CCUrlFilterProtocol can be used to append common parameters to requests before sending them.
@protocol CCUrlFilterProtocol <NSObject>
///  Preprocess request URL before actually sending them.
///
///  @param originUrl request's origin URL, which is returned by `requestUrl`
///  @param request   request itself
///
///  @return A new url which will be used as a new `requestUrl`
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(CCBaseRequest *)request;

@end

///  CCCacheDirPathFilterProtocol can be used to append common path components when caching response results
@protocol CCCacheDirPathFilterProtocol <NSObject>
///  Preprocess cache path before actually saving them.
///
///  @param originPath original base cache path, which is generated in `YTKRequest` class.
///  @param request    request itself
///
///  @return A new path which will be used as base path when caching.
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(CCBaseRequest *)request;
@end


@interface CCNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Return a shared config object.
+ (CCNetworkConfig *)sharedConfig;

///  Request base URL, such as "http://www.ashless.com". Default is empty string.
@property (nonatomic, strong) NSString *baseUrl;
///  Request CDN URL. Default is empty string.
@property (nonatomic, strong) NSString *cdnUrl;
///  URL filters. See also `CCUrlFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<CCUrlFilterProtocol>> *urlFilters;
///  Cache path filters. See also `CCCacheDirPathFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<CCCacheDirPathFilterProtocol>> *cacheDirPathFilters;
///  Security policy will be used by AFNetworking. See also `AFSecurityPolicy`.
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
///  Whether to log debug info. Default is NO;
@property (nonatomic) BOOL debugLogEnabled;
///  SessionConfiguration will be used to initialize AFHTTPSessionManager. Default is nil.
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

/// request timeoutInterval defalut 20;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// allows Cellular Access default YES;
@property (nonatomic, assign) BOOL allowsCellularAccess;

///  Add a new URL filter.
- (void)addUrlFilter:(id<CCUrlFilterProtocol>)filter;
///  Remove all URL filters.
- (void)clearUrlFilter;
///  Add a new cache path filter
- (void)addCacheDirPathFilter:(id<CCCacheDirPathFilterProtocol>)filter;
///  Clear all cache path filters.
- (void)clearCacheDirPathFilter;

@end

NS_ASSUME_NONNULL_END
