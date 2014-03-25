//
//  SearchResultCell.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpBusinessListing.h"

@interface SearchResultCell : UITableViewCell
@property (strong, nonatomic) YelpBusinessListing* business;
@end
