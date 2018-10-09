//
//  CCBaseRequest.h
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const CCRequestValidationErrorDomain;


NS_ENUM(NSInteger) {
    CCRequestValidationErrorInvalidStatusCode = -8,
    CCRequestValidationErrorInvalidJSONFormat = -9,
};

///  HTTP Request method.
typedef NS_ENUM(NSInteger, CCRequestMethod) {
    CCRequestMethodGET = 0,
    CCRequestMethodPOST,
    // 下面的不常用，不过也写上吧
    CCRequestMethodHEAD,
    CCRequestMethodPUT,
    CCRequestMethodDELETE,
    CCRequestMethodPATCH,
};

///  Request serializer type.
typedef NS_ENUM(NSInteger, CCRequestSerializerType) {
    CCRequestSerializerTypeHTTP = 0,
    CCRequestSerializerTypeJSON,
};

///  Response serializer type, which determines response serialization process and
///  the type of `responseObject`.
typedef NS_ENUM(NSInteger, CCResponseSerializerType) {
    /// NSData type
    CCResponseSerializerTypeHTTP,
    /// JSON object type
    CCResponseSerializerTypeJSON,
    /// NSXMLParser type
    CCResponseSerializerTypeXMLParser,
};

///  Request priority
typedef NS_ENUM(NSInteger, CCRequestPriority) {
    CCRequestPriorityLow = -4L,
    CCRequestPriorityDefault = 0,
    CCRequestPriorityHigh = 4,
};

@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);

@class CCBaseRequest;
typedef void(^CCRequestCompletionBlock)(__kindof CCBaseRequest * request);
@protocol CCRequestDelegate <NSObject>

@optional
///  Tell the delegate that the request has finished successfully.
///
///  @param request The corresponding request.
- (void)requestFinished:(__kindof CCBaseRequest *)request;

///  Tell the delegate that the request has failed.
///
///  @param request The corresponding request.
- (void)requestFailed:(__kindof CCBaseRequest *)request;

@end

@protocol CCRequestAccessory <NSObject>

@optional
///  Inform the accessory that the request is about to start.
///
///  @param request The corresponding request.
- (void)requestWillStart:(id)request;

///  Inform the accessory that the request is about to stop. This method is called
///  before executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestWillStop:(id)request;

///  Inform the accessory that the request has already stoped. This method is called
///  after executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestDidStop:(id)request;

@end


@interface CCBaseRequest : NSObject
#pragma mark - Request and Response Information
///=============================================================================
/// @name Request and Response Information
///=============================================================================

///  The underlying NSURLSessionTask.
///
///  @warning This value is actually nil and should not be accessed before the request starts.
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

///  Shortcut for `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;

///  Shortcut for `requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;

///  Shortcut for `requestTask.response`.
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

///  The response status code.
@property (nonatomic, readonly) NSInteger responseStatusCode;

///  The response header fields.
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

///  The raw data representation of response. Note this value can be nil if request failed.
@property (nonatomic, strong, readonly, nullable) NSData *responseData;

///  The string representation of response. Note this value can be nil if request failed.
@property (nonatomic, strong, readonly, nullable) NSString *responseString;

///  This serialized response object. The actual type of this object is determined by
///  `YTKResponseSerializerType`. Note this value can be nil if request failed.
///
///  @discussion If `resumableDownloadPath` and DownloadTask is using, this value will
///              be the path to which file is successfully saved (NSURL), or nil if request failed.
@property (nonatomic, strong, readonly, nullable) id responseObject;

///  If you use `YTKResponseSerializerTypeJSON`, this is a convenience (and sematic) getter
///  for the response object. Otherwise this value is nil.
@property (nonatomic, strong, readonly, nullable) id responseJSONObject;

///  This error can be either serialization error or network error. If nothing wrong happens
///  this value will be nil.
@property (nonatomic, strong, readonly, nullable) NSError *error;

///  Return cancelled state of request task.
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

///  Executing state of request task.
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

#pragma mark - Request Configuration
///=============================================================================
/// @name Request Configuration
///=============================================================================

///  Tag can be used to identify request. Default value is 0.
@property (nonatomic) NSInteger tag;

/// request parameters
@property (nonatomic, strong) NSDictionary *parameters;

///  The delegate object of the request. If you choose block style callback you can ignore this.
///  Default is nil.
@property (nonatomic, weak, nullable) id<CCRequestDelegate> delegate;

///  This can be used to add several accossories object. Note if you use `addAccessory` to add acceesory
///  this array will be automatically created. Default is nil.
@property (nonatomic, strong, nullable) NSMutableArray<id<CCRequestAccessory>> *requestAccessories;

///  This can be use to construct HTTP body when needed in POST request. Default is nil.
@property (nonatomic, copy, nullable) AFConstructingBlock constructingBodyBlock;

///  You can use this block to track the download progress. See also `resumableDownloadPath`.
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock resumableDownloadProgressBlock;

///  This value is used to perform resumable download request. Default is nil.
///
///  @discussion NSURLSessionDownloadTask is used when this value is not nil.
///              The exist file at the path will be removed before the request starts. If request succeed, file will
///              be saved to this path automatically, otherwise the response will be saved to `responseData`
///              and `responseString`. For this to work, server must support `Range` and response with
///              proper `Last-Modified` and/or `Etag`. See `NSURLSessionDownloadTask` for more detail.
@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;

///  The priority of the request. Effective only on iOS 8+. Default is `CCRequestPriorityDefault`.
@property (nonatomic) CCRequestPriority requestPriority;

@property (nonatomic, copy, nullable) CCRequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy, nullable) CCRequestCompletionBlock failureCompletionBlock;

///  Set completion callbacks
- (void)setCompletionBlockWithSuccess:(nullable CCRequestCompletionBlock)success
                              failure:(nullable CCRequestCompletionBlock)failure;

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;

///  Convenience method to add request accessory. See also `requestAccessories`.
- (void)addAccessory:(id<CCRequestAccessory>)accessory;

#pragma mark - Request Action
///=============================================================================
/// @name Request Action
///=============================================================================

///  Append self to request queue and start the request.
- (void)start;

///  Remove self from request queue and cancel the request.
- (void)stop;

///  Convenience method to start the request with block callbacks.
- (void)startWithCompletionBlockWithSuccess:(nullable CCRequestCompletionBlock)success
                                    failure:(nullable CCRequestCompletionBlock)failure;

#pragma mark - Subclass Override

///  Called on background thread after request succeded but before switching to main thread. Note if
///  cache is loaded, this method WILL be called on the main thread, just like `requestCompleteFilter`.
- (void)requestCompletePreprocessor;

///  Called on the main thread after request succeeded.
- (void)requestCompleteFilter;

///  Called on background thread after request failed but before switching to main thread. See also
///  `requestCompletePreprocessor`.
- (void)requestFailedPreprocessor;

///  Called on the main thread when request failed.
- (void)requestFailedFilter;

///  The baseURL of request. This should only contain the host part of URL, e.g., http://www.example.com.
///  See also `requestUrl`
@property (nonatomic, copy) NSString *baseUrl;

///  The URL path of request. This should only contain the path part of URL, e.g., /v1/user. See alse `baseUrl`.
///  Additionaly, if `requestUrl` itself is a valid URL, it will be used as the result URL and
///  `baseUrl` will be ignored.
@property (nonatomic, copy) NSString *requestUrl;

///  Optional CDN URL for request.
@property (nonatomic, copy, readonly) NSString *cdnUrl;

///  HTTP request method.
@property (nonatomic, assign) CCRequestMethod requestMethod;

///  Request serializer type.
- (CCRequestSerializerType)requestSerializerType;

///  Response serializer type. See also `responseObject`.
- (CCResponseSerializerType)responseSerializerType;

///  Username and password used for HTTP authorization. Should be formed as @[@"Username", @"Password"].
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray;

///  Additional HTTP request header field.
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;

///  Use this to build custom request. If this method return non-nil value, `requestUrl`, `requestTimeoutInterval`,
///  `allowsCellularAccess`, `requestMethod` and `requestSerializerType` will all be ignored.
- (nullable NSURLRequest *)buildCustomUrlRequest;

///  Should use CDN when sending request.
- (BOOL)useCDN;

///  Whether the request is allowed to use the cellular radio (if present). Default is YES.
- (BOOL)allowsCellularAccess;

///  The validator will be used to test if `responseJSONObject` is correctly formed.
- (nullable id)jsonValidator;

///  This validator will be used to test if `responseStatusCode` is valid.
- (BOOL)statusCodeValidator;

@end

NS_ASSUME_NONNULL_END
