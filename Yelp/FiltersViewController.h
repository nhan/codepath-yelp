//
//  FiltersViewController.h
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FiltersDelegate <NSObject>
- (NSDictionary*) filters;
- (void)didConfirmFilter:(NSDictionary*)filters;
- (void)didCancelFilter;
@end

@interface FiltersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) id<FiltersDelegate> delegate;
@end

