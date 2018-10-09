//
//  CCRequest.h
//  CCNetwork
//
//  Created by ash on 2018/9/27.
//

#import "CCBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const CCRequestCacheErrorDomain;

NS_ENUM(NSInteger) {
    CCRequestCacheErrorExpired = -1,
    CCRequestCacheErrorVersionMismatch = -2,
    CCRequestCacheErrorSensitiveDataMismatch = -3,
    CCRequestCacheErrorAppVersionMismatch = -4,
    CCRequestCacheErrorInvalidCacheTime = -5,
    CCRequestCacheErrorInvalidMetadata = -6,
    CCRequestCacheErrorInvalidCacheData = -7,
};
    

NS_ENUM(NSInteger, CCRequestCacheOptions) {
    CCRequestCacheOptionsDefault,
    CCRequestCacheOptionsOnlySave,
    CCRequestCacheOptionsLoadCache
};

///  CCRequest is the base class you should inherit to create your own request class.
///  Based on CCBaseRequest, CCRequest adds local caching feature. Note download
///  request will not be cached whatsoever, because download request may involve complicated
///  cache control policy controlled by `Cache-Control`, `Last-Modified`, etc.
@interface CCCacheRequest : CCBaseRequest

///  Also note that this option does not affect storing the response, which means response will always be saved
///  even `ignoreCache` is YES.
@property (nonatomic, assign) BOOL ignoreCache;

///  The max time duration that cache can stay in disk until it's considered expired.
///  Default is -1, which means response is not actually saved as cache.
@property (nonatomic, assign) NSTimeInterval cacheTimeInterval;

///  Whether data is from local cache.
- (BOOL)isDataFromCache;

///  Manually load cache from storage.
///
///  @param error If an error occurred causing cache loading failed, an error object will be passed, otherwise NULL.
///
///  @return Whether cache is successfully loaded.
- (BOOL)loadCacheWithError:(NSError * __autoreleasing *)error;

///  Start request without reading local cache even if it exists. Use this to update local cache.
- (void)startWithoutCache;

///  Save response data (probably from another request) to this request's cache location
- (void)saveResponseDataToCacheFile:(NSData *)data;

///  Version can be used to identify and invalidate local cache. Default is 0.
- (long long)cacheVersion;

///  Whether cache is asynchronously written to storage. Default is YES.
- (BOOL)writeCacheAsynchronously;

@end

NS_ASSUME_NONNULL_END
