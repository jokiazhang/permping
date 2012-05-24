//
//  Taglist_LinkSourceRequest.m
//  EyeconSocial
//
//  Created by PhongLe on 4/19/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_LinkSourceRequest.h"
#import "EyeConstant.h"

@implementation Taglist_LinkSourceRequest

- (NSData *)requestToXMLBody
{
    NSMutableString *request = [[NSMutableString alloc] init];
    [request appendFormat: @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"
     "<Request><Head>\n"
     "<Version Major=\"1\" Minor=\"0\"/>"
     "<Type Command=\"%@\" Service=\"%@\"/>"
     "</Head><Body>", @"EnablePersonalAccess", @"User"];
    
    
    NSUInteger paramNum = [parameterValue count];
    for(NSInteger index = 0; index < paramNum; index ++) {
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
    
    [request appendString:@"</Body></Request>"];
    NSData *result = [request dataUsingEncoding:NSUTF8StringEncoding];
    [request release];
    return result;	 
}
@end
