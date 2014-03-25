//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpBusinessListing.h"
#import "SearchResultCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *filters;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.searchResults = [[NSMutableArray alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filters = [[NSMutableDictionary alloc] init];
        self.filters[@"term"] = @"Italian";
        self.filters[@"location"] = @"San Francisco";
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self doSearchRequest];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *resultCellNib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    [self.searchResultsTable registerNib:resultCellNib forCellReuseIdentifier:@"Test"];
    self.searchResultsTable.delegate = self;
    self.searchResultsTable.dataSource = self;
    self.searchBar.delegate = self;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
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

- (void)doSearchRequest
{
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didClickFilter
{
    // TODO: probably shouldn't initialize this every time?
    FiltersViewController *filtersController = [[FiltersViewController alloc] init];

    
    // TODO: should probably move this logic to setter
    [self deepCopyFilterFrom:self.filters to:filtersController.filters];
    
    filtersController.delegate = self;

    
    // wrap filtersController in a nav controller to get cancel and search buttons
    UINavigationController *wrapperNavController = [[UINavigationController alloc] initWithRootViewController:filtersController];
    [self presentViewController:wrapperNavController animated:YES completion: nil];
}

// TODO: write a better copy method(s) somewhere else
- (void)deepCopyFilterFrom:(NSDictionary*)from to:(NSMutableDictionary*)to
{
    [self setNilableValueInDict:to key:@"term" value:from[@"term"]];
    [self setNilableValueInDict:to key:@"location" value:from[@"location"]];
    [self setNilableValueInDict:to key:@"radius_filter" value:from[@"radius_filter"]];
    [self setNilableValueInDict:to key:@"sort" value:from[@"sort"]];
}

// TODO: should probably write category for this
// deletes value from dict if nil
- (void)setNilableValueInDict:(NSMutableDictionary*)dict key:(id)key value:(id)value
{
    if (value) {
        dict[key] = value;
    } else {
        [dict removeObjectForKey:key];
    }
}

- (void)confirmFilter:(NSDictionary*)filters
{
    [self deepCopyFilterFrom:filters to:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self doSearchRequest];
}

- (void)cancelFilter
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.filters[@"term"] = searchBar.text;
    [self doSearchRequest];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test"];

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
