//
//  CCBaseRequest.m
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import "CCBaseRequest.h"
#import "CCNetworkPrivate.h"
#import "CCNetworkAgent.h"

NSString *const CCRequestValidationErrorDomain = @"com.ash.request.validation";

@interface CCBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation CCBaseRequest

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}


#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(CCRequestCompletionBlock)success
                              failure:(CCRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)addAccessory:(id<CCRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}


#pragma mark - Request Action

- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[CCNetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[CCNetworkAgent sharedAgent] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (void)startWithCompletionBlockWithSuccess:(CCRequestCompletionBlock)success
                                    failure:(CCRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}



#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
    CCLog(@"%@ requestCompletePreprocessor", NSStringFromClass([self class]));
}

- (void)requestCompleteFilter {
    CCLog(@"%@ requestCompleteFilter", NSStringFromClass([self class]));
}

- (void)requestFailedPreprocessor {
    CCLog(@"%@ requestFailedPreprocessor", NSStringFromClass([self class]));
}

- (void)requestFailedFilter {
    CCLog(@"%@ requestFailedFilter", NSStringFromClass([self class]));
}

- (NSString *)requestUrl {
    return _requestUrl;
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return _baseUrl;
}

- (CCRequestMethod)requestMethod {
    return _requestMethod;
}

- (CCRequestSerializerType)requestSerializerType {
    return CCRequestSerializerTypeHTTP;
}

- (CCResponseSerializerType)responseSerializerType {
    return CCResponseSerializerTypeJSON;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}


#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { parameters: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.parameters];
}


@end
