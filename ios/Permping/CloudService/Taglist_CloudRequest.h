//
//  Taglist_CloudRequest.h
//  Eyecon
//
//  Created by PhongLe on 8/25/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Taglist_CloudRequest : NSObject { 
	NSString				*method;
    NSString                *contentType;
    NSString				*protocolVersion;
    NSString                *requestURL;
    
	NSMutableArray			*parameterName;
	NSMutableArray			*parameterValue;    
    
    NSMutableDictionary     *additionalHeaders;
    
    BOOL                    shouldFollowRedirect;
} 

@property (nonatomic, copy)     NSString                *method;
@property (nonatomic, copy)     NSString                *contentType;
@property (nonatomic, copy)     NSString				*protocolVersion;
@property (nonatomic, copy)     NSString                *requestURL;
@property (nonatomic, assign)   BOOL                    shouldFollowRedirect;

- (void) addParameter:(NSString *)name value:(NSString *)val;
 
- (NSData *)requestToXMLBody;
- (NSString *)getTargetRequestURL;
- (void)setAdditionalHeaderName:(NSString *)name value:(NSString *)val; 
- (NSDictionary *)getAdditionalHeaders;
- (void)addFilterForFieldName:(NSString *)name filterOp:(NSString *)op filterValue:(NSString *)val;
- (void)setSortingByField:(NSString *)field asc:(BOOL)asc;

- (NSString *)parameterListForGetMethod;

@end
