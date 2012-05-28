//
//  Taglist_CloudResponse.h
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponseProtocol.h"
#import "ErrorModel.h"

@interface Taglist_CloudResponse : NSObject <Taglist_CloudResponseProtocol> { 
	NSInteger			httpCode;
    NSDictionary        *responseHeaders;     
	NSError             *parsingError;
    NSData              *pureResponseData;
    
    ErrorModel          *errorModel;
}
@property (nonatomic, assign)   BOOL                keepPureData;
@property (nonatomic, retain)   NSData              *pureResponseData;
@property (nonatomic, assign)   NSInteger			httpCode;
@property (nonatomic, retain)   NSDictionary        *responseHeaders;
@property (nonatomic, retain)   NSError             *parsingError;

// tuan add : for check response error
@property (nonatomic, readonly)   NSError             *responseError;
 
- (BOOL)isHTTPSuccess;  
- (NSString *)getHTTPErrorMessage;
@end
