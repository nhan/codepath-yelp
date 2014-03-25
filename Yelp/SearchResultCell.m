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
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starsImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
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
}

@end
