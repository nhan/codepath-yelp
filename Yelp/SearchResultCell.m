//
//  SearchResultCell.m
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchResultCell.h"
#import <UIImageView+AFNetworking.h>

@interface SearchResultCell ()
@end

@implementation SearchResultCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(YelpBusinessListing *)business
{
    _business = business;
    self.nameLabel.text = business.name;
    [self.mainImage setImageWithURL:business.mainImageURL];
    [self.starsImage setImageWithURL:business.starsRatingImageURL];
    self.addressLabel.text = business.address;
    self.categoriesLabel.text = business.categories;
    self.numRatingsLabel.text = [NSString stringWithFormat:@"%d reviews", business.numReviews];
}

@end
