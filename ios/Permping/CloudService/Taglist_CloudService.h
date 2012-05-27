//
//  Taglist_CloudService.h
//  EyeconSocial
//
//  Created by PhongLe on 7/14/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"
#import "CategoryListResponse.h"
#import "BoardListReponse.h"

@interface Taglist_CloudService : NSObject 
{
    
} 

+ (NSString *)getTaglistHTTPURLBase;
+ (PermListResponse *)getPopularListWithRequestCount:(NSUInteger)count nextItemId:(NSInteger)nextId;
+ (CategoryListResponse*)getCategoryList;
+ (BoardListReponse*)getBoardListWithCategoryId:(NSString*)categoryId;
+ (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;
@end
