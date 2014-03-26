//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpBusinessListing.h"
#import "SearchResultCell.h"
#import "FiltersViewController.h"
#import "MMProgressHud.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *filters;
//@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.searchResults = [[NSMutableArray alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.distanceFilter = kCLDistanceFilterNone;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        [self.locationManager startUpdatingLocation];
//        
//        float latitude = self.locationManager.location.coordinate.latitude;
//        float longitude = self.locationManager.location.coordinate.longitude;
//        NSString* coordinates = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
        
        self.filters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term":@"food", @"location":@"San Francisco"}];
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self doSearch];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *resultCellNib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    [self.searchResultsTable registerNib:resultCellNib forCellReuseIdentifier:@"SearchResultCell"];
    self.searchResultsTable.delegate = self;
    self.searchResultsTable.dataSource = self;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didClickFilter)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSearch
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    [MMProgressHUD showWithStatus:@"Loading"];
    [self.client search:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            id businesses = response[@"businesses"];
            if ([businesses isKindOfClass:[NSArray class]]) {
                [self.searchResults removeAllObjects];
                for (NSDictionary* dict in businesses) {
                    [self.searchResults addObject:[YelpBusinessListing listingFromDictionary:dict]];
                }
                [self.searchResultsTable reloadData];
            }
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismiss];
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didClickFilter
{
    // TODO: probably shouldn't initialize this every time?
    FiltersViewController *filtersController = [[FiltersViewController alloc] init];
    filtersController.delegate = self;

    // wrap filtersController in a nav controller to get cancel and search buttons
    UINavigationController *wrapperNavController = [[UINavigationController alloc] initWithRootViewController:filtersController];
    [self presentViewController:wrapperNavController animated:YES completion: nil];
}

- (void)didConfirmFilter:(NSDictionary*)filters
{
    self.filters = [filters mutableCopy];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self doSearch];
}

- (void)didCancelFilter
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = self.filters[@"term"];
    self.searchBar.showsCancelButton = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    self.filters[@"term"] = searchBar.text;
    [self doSearch];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];

    cell.business = self.searchResults[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: get font and actual width from a real label
    CGSize maximumLabelSize = CGSizeMake(205, MAXFLOAT);
    YelpBusinessListing *business = self.searchResults[indexPath.row];
    CGRect nameRect = [business.name boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    CGRect addressRect = [business.address boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    CGRect categoriesRect = [business.categories boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    CGFloat ret = 5 + nameRect.size.height + 5 + 17 + 5 + addressRect.size.height + 5 + categoriesRect.size.height + 5;
    
    return ret < 110 ? 110 : ret;
}

@end
