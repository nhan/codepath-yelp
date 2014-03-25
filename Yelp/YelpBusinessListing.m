//
//  YelpBusinessListing.m
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpBusinessListing.h"

@implementation YelpBusinessListing
+ (YelpBusinessListing*) listingFromDictionary:(NSDictionary*) dict
{
    YelpBusinessListing *ret = [[YelpBusinessListing alloc] init];
    
    // TODO: find a mapping library so we don't have to do this by hand
    ret.name = dict[@"name"];
    ret.numReviews = [dict[@"review_count"] integerValue];
    ret.starsRatingImageURL = [NSURL URLWithString:dict[@"rating_img_url"]];
    ret.mainImageURL = [NSURL URLWithString:dict[@"image_url"]];
    
    NSString* address = dict[@"location"][@"display_address"][0];
    ret.address = address;
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (NSArray* arrayOfNames in dict[@"categories"]) {
        // the categories field is made of an array of array
        // the first element of the array is the display name
        // not sure why this part of the API is inconsistent with the rest
        [categories addObject:arrayOfNames[0]];
    }
    ret.categories = [categories componentsJoinedByString:@", "];

    // TODO: distance
    return ret;
}

@end
