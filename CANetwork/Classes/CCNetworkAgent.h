//
//  CCNetworkAgent.h
//  CCNetwork
//
//  Created by ash on 2018/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CCBaseRequest;

///  CCNetworkAgent is the underlying class that handles actual request generation,
///  serialization and response handling.
@interface CCNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared agent.
+ (CCNetworkAgent *)sharedAgent;

///  Add request to session and start it.
- (void)addRequest:(CCBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(CCBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

///  Return the constructed URL of request.
///
///  @param request The request to parse. Should not be nil.
///
///  @return The result URL.
- (NSString *)buildRequestUrl:(CCBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
