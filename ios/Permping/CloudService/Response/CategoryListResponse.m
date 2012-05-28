//
//  CategoryListResponse.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryListResponse.h"

@interface CategoryListResponse()
@property (nonatomic, retain) NSMutableArray        *categoryList;
@property (nonatomic, retain) CategoryModel         *currentCategory;
@end


@implementation CategoryListResponse
@synthesize categoryList;
@synthesize currentCategory;

- (void)dealloc {
    self.categoryList = nil;
    self.currentCategory = nil;
    [super dealloc];
}

- (NSArray *)getResponseCategoryList
{
    if (self.categoryList) {
        return [NSArray arrayWithArray:self.categoryList];
    }
    return nil;
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
    
    if ([@"/response/categories/item" isEqualToString:path]) 
	{
		CategoryModel *model = [[CategoryModel alloc] init];
        self.currentCategory = model;
        [model release];
	}
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    
    if ([@"/response/categories/item/title" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
        if (self.currentCategory) {
            self.currentCategory.title = [[text copy] autorelease];
        }
        [text release];
	}
    return;
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
    //NSLog(@"onEndElement:%@ name:%@ text:\"%@\"", path, name, text);
	if ([@"/response/categories/item/id" isEqualToString:path]) 
	{
        if (self.currentCategory)
            self.currentCategory.categoryId = [[text copy] autorelease];
	} else if ([@"/response/categories/item" isEqualToString:path]) {
        if (self.currentCategory) {
            if (!self.categoryList) {
                NSMutableArray *array= [[NSMutableArray alloc] init];
                self.categoryList = array;
                [array release];
            }
            [self.categoryList addObject:self.currentCategory];
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
