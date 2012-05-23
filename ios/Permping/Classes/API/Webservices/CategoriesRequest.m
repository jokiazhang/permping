//
//  CategoriesRequest.m
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesRequest.h"
#import "Constants.h"
#import "WSCategory.h"

@implementation CategoriesRequest

-(id)handleXMLResponse:(CXMLDocument *)in_document error:(NSError **)out_error{
    NSArray *lc_categoriesXml = [in_document nodesForXPath:@"/response/category" error:out_error];
    if (!*out_error) {
        if ([lc_categoriesXml count] > 0) {
            NSMutableArray *lc_categories = [NSMutableArray array];
            for(CXMLElement *lc_element in lc_categoriesXml) {
                WSCategory *lc_category = [[WSCategory alloc] initWithXmlElement:lc_element];
                [lc_categories addObject: lc_category];
                [lc_category release];
            }
            return lc_categories;
        }
    }
    return nil;
}

- (NSString*)urlString {
    return [SERVER_API stringByAppendingString:@"/permservice/getcategories"];
}

- (NSString*)urlSpecificPart {
    return @"";
}

@end
