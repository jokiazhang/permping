//
//  ErrorModel.h
//  Permping
//
//  Created by Andrew Duck on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorModel : NSObject {
    NSString    *code;
    NSString    *message;
}
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@end
