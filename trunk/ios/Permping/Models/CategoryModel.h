//
//  CategoryModel.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject {
    NSString    *categoryId;
    NSString    *title;
}
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *title; 

@end
