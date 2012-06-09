//
//  PermActionResponse.m
//  Permping
//
//  Created by MAC on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermActionResponse.h"

@interface PermActionResponse ()
@property (nonatomic, retain) NSString *totalLikes;
@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) NSString *totalComment;
@property (nonatomic, retain) NSString *commentId;
@property (nonatomic, retain) NSString *permId;
@property (nonatomic, retain) UserModel *currentUser;
@property (nonatomic, retain) CommentModel *currentComment;
@end

@implementation PermActionResponse
@synthesize totalLikes, status;
@synthesize totalComment, commentId, permId, currentUser, currentComment;
- (void)dealloc {
    self.status = nil;
    self.totalLikes = nil;
    self.totalComment = nil;
    self.commentId = nil;
    self.permId = nil;
    self.currentUser = nil;
    self.currentComment = nil;
    [super dealloc];
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
    if ([@"/response/l_user" isEqualToString:path]) {
        UserModel *model = [[UserModel alloc] init];
        self.currentUser = model;
        [model release];
    } if ([@"/response/cmnt" isEqualToString:path]) {
        CommentModel *model = [[CommentModel alloc] init];
        self.currentComment = model;
        [model release];
    }
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    if ([@"/response/cmnt" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentComment) {
            self.currentComment.content = [[text copy] autorelease];
        }
        [text release];
	}  else if ([@"/response/l_user/l_userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
    return;
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
    //NSLog(@"onEndElement:%@ name:%@ text:\"%@\"", path, name, text);
	if ([@"/response/like/totallikes" isEqualToString:path]) 
	{
        self.totalLikes = [[text copy] autorelease];
	} else if ([@"/response/like/status" isEqualToString:path]) {
        self.status = [[text copy] autorelease];
	} else if ([@"/response/status" isEqualToString:path]) {
        self.status = [[text copy] autorelease];
	} else if ([@"/response/totalcomments" isEqualToString:path]) {
        self.totalComment = [[text copy] autorelease];
	}  else if ([@"/response/id" isEqualToString:path]) {
        self.commentId = [[text copy] autorelease];
	} else if ([@"/response/permId" isEqualToString:path]) {
        self.permId = [[text copy] autorelease];
	} else if ([@"/response/l_user/l_userId" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.userId = [[text copy] autorelease];
        }
	} else if ([@"/response/l_user/l_status" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.userStatus = [[text copy] autorelease];
        }
	} else if ([@"/response/l_user/l_userAvatar" isEqualToString:path]) {
        if (self.currentUser) {
            self.currentUser.userAvatar = [[text copy] autorelease];
        }
	} else if ([@"/response/l_user" isEqualToString:path]) {
        if (self.currentComment) {
            self.currentComment.commentUser = self.currentUser;
        }
    }
   	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    [super onAttribute:path name:name value:value];
    
    return;	   	
} 

- (void) onParsingError:(NSError *)error
{
    [super onParsingError:error];
    NSLog(@"ERRRRRO = %@",error.description);
}


/* like
 <response>
 <like>
 <totallikes>4</totallikes>
 <status>1</status>
 </like>
 </response>
 */

@end
