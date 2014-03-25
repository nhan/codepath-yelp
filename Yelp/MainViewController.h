//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
// TODO: move this to a aptly named delegate
- (void)confirmFilter:(NSDictionary*)filters;
- (void)cancelFilter;
@end
