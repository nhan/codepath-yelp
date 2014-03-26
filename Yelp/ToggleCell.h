//
//  ToggleCell.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (strong, nonatomic) NSString* meta;
@end
