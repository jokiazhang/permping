//
//  Taglist_FeedListResponse.m
//  EyeconSocial
//
//  Created by Phong Le on 4/10/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "PermListResponse.h"

@interface PermListResponse()
@property (nonatomic, retain) NSMutableArray        *permList;
@property (nonatomic, retain) NSMutableArray        *permCommentList;
@property (nonatomic, retain) PermModel             *currentPerm;
@property (nonatomic, retain) CommentModel          *currentComment;
@property (nonatomic, retain) UserModel          *currentUser;
@end

@implementation PermListResponse
@synthesize permList;
@synthesize permCommentList;
@synthesize currentPerm;
@synthesize currentComment;
@synthesize currentUser;
@synthesize permFromBoard;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    self.permList = nil;
    self.currentPerm = nil;
    self.permCommentList = nil;
    self.currentComment = nil;
    self.currentUser = nil;
    [super dealloc];
}

- (NSArray *)getResponsePermList
{
    if (self.permList) {
        return [NSArray arrayWithArray:self.permList];
    }
    return nil;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////
// Temp

- (void) permFromBoardOnStartElement:(NSString *)path name:(NSString *)name
{
    if ([@"/response/perms/item" isEqualToString:path]) 
	{
		PermModel *model = [[PermModel alloc] init];
        self.currentPerm = model;
        [model release];
	}
    else if ([@"/response/perms/item/permComments/comment" isEqualToString:path]) 
	{
		CommentModel *model = [[CommentModel alloc] init];
        self.currentComment = model;
        [model release];
	} 
    else if ([@"/response/perms/item/permComments/comment/content" isEqualToString:path]) 
	{
		NSLog(@"okokokokoko");
	}
    else if ([@"/response/perms/item/permComments/comment/user" isEqualToString:path]) 
	{
		UserModel *model = [[UserModel alloc] init];
        self.currentUser = model;
        [model release];
	}
    else if ([@"/response/perms/item/user" isEqualToString:path]) 
	{
		UserModel *model = [[UserModel alloc] init];
        self.currentUser = model;
        [model release];
	}
	return;
}

- (void)permFromBoardFoundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    if ([@"/response/perms/item/permDesc" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentPerm) {
            self.currentPerm.permDesc = [[text copy] autorelease];
        }
        [text release];
	}
    else if ([@"/response/perms/item/permCategory" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentPerm) {
            self.currentPerm.permCategory = [[text copy] autorelease];
        }
        [text release];
	}
    else if ([@"/response/perms/item/permComments/comment/user/userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
    else if ([@"/response/perms/item/permComments/comment/content" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentComment) {
            self.currentComment.content = [[text copy] autorelease];
        }
        [text release];
    }
    else if ([@"/response/perms/item/user/userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
}

- (void) permFromBoardOnEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{       
	if ([@"/response/perms/item/permId" isEqualToString:path]) 
	{
        if (self.currentPerm)
            self.currentPerm.permId = [[text copy] autorelease];
	}
    else if ([@"/response/perms/item/permImage" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permImage = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permComments/comment" isEqualToString:path])
    {
        if (self.currentComment) {
            if (!self.permCommentList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permCommentList = array;
                [array release];
            }
            [self.permCommentList addObject:self.currentComment];
        }
    }
    else if ([@"/response/perms/item/permComments/comment/user/userId" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userId = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permComments/comment/user/status" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userStatus = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permComments/comment/user/userAvatar" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userAvatar = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permComments/comment/user" isEqualToString:path]) {
        if (self.currentComment)
            self.currentComment.commentUser = self.currentUser;
    }
    else if ([@"/response/perms/item/permComments" isEqualToString:path]) {
        if (self.currentPerm) {
            if (!self.permCommentList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permCommentList = array;
                [array release];
            }
            self.currentPerm.permComments = self.permCommentList;
        }
    }
    else if ([@"/response/perms/item/permRepinCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permRepinCount = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permLikeCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permLikeCount = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/permCommentCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permCommentCount = [[text copy] autorelease];
    }
    
    else if ([@"/response/perms/item/user/userId" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userId = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/user/status" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userStatus = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/user/userAvatar" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userAvatar = [[text copy] autorelease];
    }
    else if ([@"/response/perms/item/user" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permUser = self.currentUser;
    }
    else if ([@"/response/perms/item" isEqualToString:path])
    {
        if (self.currentPerm) {
            if (!self.permList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permList = array;
                [array release];
            }
            [self.permList addObject:self.currentPerm];
        }
    }
   	return;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
    
    if (self.permFromBoard) {
        [self permFromBoardOnStartElement:path name:name];
        return;
    }
    
    if ([@"/response/popularPerms/item" isEqualToString:path]) 
	{
		PermModel *model = [[PermModel alloc] init];
        self.currentPerm = model;
        [model release];
	}
    else if ([@"/response/popularPerms/item/permComments/comment" isEqualToString:path]) 
	{
		CommentModel *model = [[CommentModel alloc] init];
        self.currentComment = model;
        [model release];
	} 
    else if ([@"/response/popularPerms/item/permComments/comment/content" isEqualToString:path]) 
	{
		NSLog(@"okokokokoko");
	}
    else if ([@"/response/popularPerms/item/permComments/comment/user" isEqualToString:path]) 
	{
		UserModel *model = [[UserModel alloc] init];
        self.currentUser = model;
        [model release];
	}
    else if ([@"/response/popularPerms/item/user" isEqualToString:path]) 
	{
		UserModel *model = [[UserModel alloc] init];
        self.currentUser = model;
        [model release];
	}
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    
    if (self.permFromBoard) {
        [self permFromBoardFoundCDATA:CDATABlock onPath:path];
        return;
    }
    
    if ([@"/response/popularPerms/item/permDesc" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentPerm) {
            self.currentPerm.permDesc = [[text copy] autorelease];
        }
        [text release];
	}
    else if ([@"/response/popularPerms/item/permCategory" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentPerm) {
            self.currentPerm.permCategory = [[text copy] autorelease];
        }
        [text release];
	}
    else if ([@"/response/popularPerms/item/permComments/comment/user/userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
    else if ([@"/response/popularPerms/item/permComments/comment/content" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentComment) {
            self.currentComment.content = [[text copy] autorelease];
        }
        [text release];
    }
    else if ([@"/response/popularPerms/item/user/userName" isEqualToString:path]) {
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentUser) {
            self.currentUser.userName = [[text copy] autorelease];
        }
        [text release];
    }
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];  
    
    if (self.permFromBoard) {
        [self permFromBoardOnEndElement:path name:name text:text];
        return;
    }
    
	if ([@"/response/popularPerms/item/permId" isEqualToString:path]) 
	{
        if (self.currentPerm)
            self.currentPerm.permId = [[text copy] autorelease];
	}
    else if ([@"/response/popularPerms/item/permImage" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permImage = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permComments/comment" isEqualToString:path])
    {
        if (self.currentComment) {
            if (!self.permCommentList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permCommentList = array;
                [array release];
            }
            [self.permCommentList addObject:self.currentComment];
        }
    }
    else if ([@"/response/popularPerms/item/permComments/comment/user/userId" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userId = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permComments/comment/user/status" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userStatus = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permComments/comment/user/userAvatar" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userAvatar = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permComments/comment/user" isEqualToString:path]) {
        if (self.currentComment)
            self.currentComment.commentUser = self.currentUser;
    }
    else if ([@"/response/popularPerms/item/permComments" isEqualToString:path]) {
        if (self.currentPerm) {
            if (!self.permCommentList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permCommentList = array;
                [array release];
            }
            self.currentPerm.permComments = self.permCommentList;
        }
    }
    else if ([@"/response/popularPerms/item/permRepinCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permRepinCount = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permLikeCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permLikeCount = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/permCommentCount" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permCommentCount = [[text copy] autorelease];
    }
    
    else if ([@"/response/popularPerms/item/user/userId" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userId = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/user/status" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userStatus = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/user/userAvatar" isEqualToString:path]) {
        if (self.currentUser)
            self.currentUser.userAvatar = [[text copy] autorelease];
    }
    else if ([@"/response/popularPerms/item/user" isEqualToString:path]) {
        if (self.currentPerm)
            self.currentPerm.permUser = self.currentUser;
    }
    else if ([@"/response/popularPerms/item" isEqualToString:path])
    {
        if (self.currentPerm) {
            if (!self.permList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.permList = array;
                [array release];
            }
            [self.permList addObject:self.currentPerm];
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

@end
