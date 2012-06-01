//
//  Taglist_CloudRequestDispatcher.h
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponseProtocol.h"
#import "Taglist_CloudRequest.h"
 
@interface Taglist_CloudRequestDispatcher : NSObject <UIAlertViewDelegate>
{
 
}
+ (Taglist_CloudRequestDispatcher *)getInstance;
 
- (void)dispatchRequest:(Taglist_CloudRequest *)request response:(id<Taglist_CloudResponseProtocol>)response;
- (void)dispatchSimpleMultipartRequest:(Taglist_CloudRequest *)request response:(id<Taglist_CloudResponseProtocol>)response;
- (NSData *)sendSynchronizeRequestWithCloud:(Taglist_CloudRequest *)request response:(id<Taglist_CloudResponseProtocol>)response;
- (void)displayClientUpgradeMessageAndLaunchAppStore:(NSString *)message;
- (void)displayServerPushErrorMessage:(NSString *)message;
@end

@interface Taglist_CloudConnectionHandler : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
 	NSMutableData				*receivedData;
	BOOL						finishConnection;
	Taglist_CloudRequest		*currentRequest;
	BOOL						responseReceiveBegin;    
    BOOL                        receivedContentIsZipped;
    //Gzip is transparenly
    
	id<Taglist_CloudResponseProtocol>       responseDelegate;    
}
 
@property (nonatomic, assign) BOOL							finishConnection;
@property (nonatomic, retain) Taglist_CloudRequest			*currentRequest;
@property (nonatomic, assign) BOOL							responseReceiveBegin;
@property (nonatomic, assign) BOOL                          receivedContentIsZipped;
@property (nonatomic, retain) id<Taglist_CloudResponseProtocol>		responseDelegate;

#pragma mark NSURLConnection Delegates
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end
