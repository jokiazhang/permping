//
//  BoardModel.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardModel : NSObject {
    NSString    *boardId;
    NSString    *userId;
    NSString    *title;
    NSString    *categoryId;
    NSString    *desc;
    NSDate      *dateAdded;
    NSDate      *dateUpdated;
    NSString    *type;
    NSString    *friendId;
}

@property (nonatomic, copy) NSString    *boardId;
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *categoryId;
@property (nonatomic, copy) NSString    *desc;
@property (nonatomic, copy) NSDate      *dateAdded;
@property (nonatomic, copy) NSDate      *dateUpdated;
@property (nonatomic, copy) NSString    *type;
@property (nonatomic, copy) NSString    *friendId;

@end
