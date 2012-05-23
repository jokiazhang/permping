//
//  PermListRequest.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermListRequest.h"
#import "WSPerm.h"
#import "Constants.h"

@interface PermListRequest() 
@property (nonatomic, retain) NSString *requestId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;
@end

@implementation PermListRequest
@synthesize requestId, userName, password;

NSString * const PermListRequestOptionIDKey = @"id";
NSString * const PermListRequestOptionUserNameKey = @"userName";
NSString * const PermListRequestOptionPasswordKey = @"password";

- (void)dealloc {
    [requestId release];
    [userName release];
    [password release];
    [super dealloc];
}

- (id)initWithType:(PermListRequestType)in_type options:(NSDictionary *)options {
    self = [super init];
    if (self) {
        type = in_type;
        if (type == PermListRequestTypeFollowing) {
            if (options) {
                self.requestId = [options valueForKey:PermListRequestOptionIDKey];
                self.userName = [options valueForKey:PermListRequestOptionUserNameKey];
                self.password = [options valueForKey:PermListRequestOptionPasswordKey];
            }
            isUsingMethodPOST = YES;
        } else if (type == PermListRequestTypeBoards) {
            if (options) {
                self.requestId = [options valueForKey:PermListRequestOptionIDKey];
            }
        }
    }
    return self;
}

-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error{
    NSArray *lc_permsXml = [in_document nodesForXPath:@"/popularPerms/item" error:out_error];
   if (!*out_error) {
       if ([lc_permsXml count] > 0) {
           NSMutableArray *lc_perms = [NSMutableArray array];
           for(CXMLElement *lc_element in lc_permsXml) {
               WSPerm *lc_perm = [[WSPerm alloc] initWithXmlElement:lc_element];
               [lc_perms addObject: lc_perm];
               [lc_perm release];
           }
           return lc_perms;
       }
    }
    return nil;
}

- (NSString*)urlString {
    NSString *lc_string = @"/permservice/getpupolarperm";
    if (type == PermListRequestTypeFollowing) {
        lc_string = [NSString stringWithFormat:@"/permservice/getfollowingperm/%@", requestId];
    } else if (type == PermListRequestTypeBoards) {
        lc_string = [NSString stringWithFormat:@"/permservice/getpermwithboardid/%@", requestId];
    }
    return [SERVER_API stringByAppendingString:lc_string];
}

- (NSString*)urlSpecificPart {
    if (type == PermListRequestTypeFollowing) {
        NSString *lc_str = [NSString stringWithFormat:@"username=%@&password=%@", userName, password];
        return lc_str;
    }
    return @"";
}

@end
