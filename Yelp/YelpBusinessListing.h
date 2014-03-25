//
//  YelpBusinessListing.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpBusinessListing : NSObject
@property (atomic, strong) NSString *name;
@property (atomic, assign) NSInteger numReviews;
@property (atomic, strong) NSURL *starsRatingImageURL;
@property (atomic, strong) NSURL *mainImageURL;
@property (atomic, strong) NSString *address;
@property (atomic, strong) NSString *categories;
@property (atomic, strong) NSString *distance;

+ (YelpBusinessListing*) listingFromDictionary:(NSDictionary*) dict;
@end

