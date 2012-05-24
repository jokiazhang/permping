//
//  Taglist_CloudRequest.m
//  Eyecon
//
//  Created by PhongLe on 8/25/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudRequest.h"
#import "EyeConstant.h"
#import "Utility.h"
#import "Logger.h"
@interface Taglist_CloudRequest()
@property (nonatomic, retain)   NSMutableDictionary     *additionalHeaders;

- (NSString *)parameterListForGetMethod;

@end

@implementation Taglist_CloudRequest
@synthesize requestURL; 
@synthesize method;
@synthesize contentType;
@synthesize protocolVersion;
@synthesize additionalHeaders;
@synthesize shouldFollowRedirect;

- (void)dealloc
{ 
	[parameterName release];
	[parameterValue release];
	
    self.method = nil;
    self.contentType = nil;
    self.protocolVersion = nil;
    self.requestURL = nil;
    self.additionalHeaders = nil;
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        parameterName = [[NSMutableArray alloc] init];
        parameterValue = [[NSMutableArray alloc] init];
        
        additionalHeaders = [[NSMutableDictionary alloc] init];
        self.method = @"GET";
        self.contentType = nil;
        shouldFollowRedirect = YES;
    }
    return self;
}
 
- (void) addParameter:(NSString *)name value:(NSString *)val
{
    if (!name || !val) {
        [Logger logError:@"Taglist_CloudRequest - Error adding param with empty name/value"];
        return;
    }
    
	[parameterName addObject:name];
	[parameterValue addObject:val];
}

- (NSData *)requestToXMLBody
{
	NSMutableString *request = [[NSMutableString alloc] init];
    
    [request appendString:@"<Request>\n"];
    
    NSUInteger paramNum = [parameterValue count];
	for(NSInteger index = 0; index < paramNum; index ++)
	{
		NSString *paramName = [parameterName objectAtIndex:index];
		NSString *paramVal = [parameterValue objectAtIndex:index];
		if ([paramVal isEqualToString:TOKEN_START])
		{
			[request appendFormat:@"<%@>", paramName];
		}
		else if ([paramVal isEqualToString:TOKEN_END])
		{
			[request appendFormat:@"</%@>\n", paramName];
		}
		else if ([paramVal isEqualToString:SELF_ENDING_TOKEN])
		{
			[request appendFormat:@"<%@ />", paramName];
		}
        else if ([paramVal isEqualToString:TOKEN_NOVALUE]) {
            [request appendString:paramName];
        }
		else 
		{
			[request appendFormat: @"<%@>%@</%@>\n", paramName, paramVal, paramName]; 
        }
    }
	 
    [request appendString:@"</Request>\n"];
    NSData *result = [request dataUsingEncoding:NSUTF8StringEncoding];
    [request release];
	return result;
}
 

- (NSString *)parameterListForGetMethod
{
    NSMutableString *strParams = [[NSMutableString alloc] init];
    NSInteger paramNum = [parameterName count];
    NSString *paramName;
    NSString *paramVal;
    for(NSInteger index = 0; index < paramNum; index ++)
	{
		paramName = [parameterName objectAtIndex:index];
		paramVal = [parameterValue objectAtIndex:index];
        
        if (index == 0) {
            [strParams appendFormat:@"%@=%@", paramName, [Utility encodeURLString:paramVal]];
        }
        else {
            [strParams appendFormat:@"&%@=%@", paramName, [Utility encodeURLString:paramVal]];
        }
	}
    NSString *resultStr = [NSString stringWithString:strParams];
    [strParams release];
    return resultStr;
}
 
- (void)addFilterForFieldName:(NSString *)name filterOp:(NSString *)op filterValue:(NSString *)val
{
    [self addParameter:@"filterBy" value:name];
    [self addParameter:@"filterOp" value:op];
    [self addParameter:@"filterValue" value:val];
}

- (void)setSortingByField:(NSString *)field asc:(BOOL)asc
{
    [self addParameter:@"sortBy" value:field];
    [self addParameter:@"sortOrder" value:(asc ? @"ascending" : @"descending")];
}

- (NSString *)getTargetRequestURL
{
    if ([self.method isEqualToString:@"GET"]) {
        NSString *parameterList = [self parameterListForGetMethod];
        if (parameterList && ![parameterList isEqualToString:@""]) {
            return [NSString stringWithFormat:@"%@?%@", self.requestURL, [self parameterListForGetMethod]];
        }
        return self.requestURL;
    }
    else if ([self.method isEqualToString:@"POST"]){
        return self.requestURL;
    }
    else if ([self.method isEqualToString:@"DELETE"])
    {
        return self.requestURL;
    }
    return self.requestURL;
}

- (void)setAdditionalHeaderName:(NSString *)name value:(NSString *)val
{
    [additionalHeaders setValue:val forKey:name];
}

- (NSDictionary *)getAdditionalHeaders
{
    return [NSDictionary dictionaryWithDictionary:additionalHeaders];
}
@end
