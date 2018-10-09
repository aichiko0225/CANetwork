//
//  CCNetworkPrivate.h
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import <Foundation/Foundation.h>
#import "CCBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void CCLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@class AFHTTPSessionManager;

@interface CCNetworkUtils : NSObject

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (void)addDoNotBackupAttribute:(NSString *)path;

+ (NSString *)appVersionString;

+ (NSStringEncoding)stringEncodingWithRequest:(CCBaseRequest *)request;

+ (BOOL)validateResumeData:(NSData *)data;

@end

@interface CCBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@end

@interface CCBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

NS_ASSUME_NONNULL_END
