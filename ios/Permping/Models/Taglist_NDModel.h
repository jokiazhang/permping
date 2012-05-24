//
//  Taglist_NDModel.h
//  EyeconSocial
//
//  Created by PhongLe on 3/30/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface Taglist_NDModel : NSObject
{
    BOOL					isFetching;
    NSInteger               nextItemId;    
    NSUInteger				iRequestedCount;
    NSArray                 *arrResults;
}
@property (nonatomic, assign)	BOOL					isFetching;
@property (nonatomic, assign)	NSInteger				nextItemId; 
@property (nonatomic, assign)	NSUInteger				iRequestedCount;
@property (nonatomic, retain)	NSArray                 *arrResults;

- (BOOL)isHasMoreResult;
- (void)resetModel;
@end
