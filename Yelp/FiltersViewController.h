//
//  FiltersViewController.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface FiltersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableDictionary* filters;

// TODO: abstract out a delegate interface for this
@property (strong, nonatomic) MainViewController *delegate;
@end
