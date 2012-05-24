//
//  ThreadUtil.h
//  EyeconSocial
//
//  Created by PhongLe on 8/26/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThreadUtil : NSObject {

}

+ (BOOL)isAnyThreadRunning:(NSArray *)threads;
@end
