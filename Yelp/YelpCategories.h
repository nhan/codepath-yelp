//
//  YelpCategories.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpCategories : NSObject
- (id) initWithApiParam: (NSString*) param;
- (NSString*) apiParam;

- (void) selectCategoryAtIndex:(NSInteger)index selected:(BOOL)selected;
- (BOOL) isCategorySelectedAtIndex:(NSInteger)index;

- (NSString*) categoryAtIndex:(NSInteger)index;
- (NSInteger) count;
@end
