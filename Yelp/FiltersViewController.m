//
//  FiltersViewController.m
//  Yelp
//
//  Created by Nhan Nguyen on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray const* sections;
@property (strong, nonatomic) NSArray const* sortByOptions;
@property (strong, nonatomic) NSArray const* distanceOptions;

// TODO: encapsulate this state better, perhaps by writing more cell classes
@property (assign, nonatomic) BOOL sortByExpanded;
@property (assign, nonatomic) BOOL distanceExpanded;
@property (assign, nonatomic) BOOL categoriesExpanded;
@property (assign, nonatomic) NSInteger selectedSortByIndex;
@property (assign, nonatomic) NSInteger selectedDistanceIndex;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filters = [[NSMutableDictionary alloc] init];
        self.selectedSortByIndex = 0;
        self.selectedDistanceIndex = 0;
        self.sections = @[@"Sort by", @"Distance", @"Category", @"Other"];
        self.sortByOptions =  @[@"Best matched", @"Distance", @"Highest Rated"];
        self.distanceOptions = @[@[@0,@"Automatic"], @[@0.3,@"0.3 miles"], @[@1.0,@"1 mile"], @[@5.0,@"5 miles"], @[@20.0,@"20 miles"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(cancelFilter)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *searchButton= [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(confirmFilter)];
    self.navigationItem.rightBarButtonItem = searchButton;
    // Do any additional setup after loading the view from its nib.
}

- (void) setDelegate:(MainViewController *)delegate
{
    _delegate = delegate;
    
    self.selectedSortByIndex = [self.filters[@"sort"] integerValue];
    self.selectedDistanceIndex = 0;
    for (int i = 1; i < self.distanceOptions.count; ++i) {
        NSLog(@"%@", self.distanceOptions[i][0]);
        // TODO: shady float comparision going on here
        if (self.filters[@"radius_filter"] && [self.distanceOptions[i][0] isEqualToNumber:self.filters[@"radius_filter"]]) {
            self.selectedDistanceIndex = i;
        }
    }
}

- (void) cancelFilter
{
    [self.delegate cancelFilter];
}

- (void) confirmFilter
{
    [self.delegate confirmFilter:self.filters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.sortByExpanded ? self.sortByOptions.count : 1;
        case 1:
            return self.distanceExpanded ? self.distanceOptions.count : 1;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: { // sort by
            self.sortByExpanded = !self.sortByExpanded;
            if (self.sortByExpanded) {
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.sortByOptions.count
                                                                  exclude:self.selectedSortByIndex];
                [self.table insertRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            } else { // set value in filters dictionary and helper var
                self.selectedSortByIndex = indexPath.row;
                self.filters[@"sort"] = [NSNumber numberWithInteger:indexPath.row];
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.sortByOptions.count
                                                                  exclude:indexPath.row];
                [self.table deleteRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
        case 1: { // distance
            self.distanceExpanded = !self.distanceExpanded;
            if (self.distanceExpanded) {
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.distanceOptions.count
                                                                  exclude:self.selectedDistanceIndex];
                
                [self.table insertRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else { // set value in filters dictionary and index helper var
                self.selectedDistanceIndex = indexPath.row;
                
                // only set the value in filters dictionary if it is not automatic
                [self.filters removeObjectForKey:@"radius_filter"];
                if (indexPath.row >= 1) {
                    self.filters[@"radius_filter"] = self.distanceOptions[indexPath.row][0];
                }
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.distanceOptions.count
                                                                  exclude:indexPath.row];
                [self.table deleteRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];

            }
        }
        case 2: // category
            break;
        case 3: // other
            break;
    }
}

- (NSArray*) changedIndexPathsForSection:(NSInteger)section startRow:(NSInteger)start endRow:(NSInteger)end exclude:(NSInteger)exclude
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (int row = start; row < end; ++row) {
        if (row != exclude) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
            [ret addObject:path];
        }
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    switch (indexPath.section) {
        case 0: {// sort by
            if (self.sortByExpanded) {
                cell.textLabel.text = self.sortByOptions[indexPath.row];
                if (self.selectedSortByIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.textLabel.text = self.sortByOptions[self.selectedSortByIndex];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        }
        case 1: {// distance
            if (self.distanceExpanded) {
                cell.textLabel.text = self.distanceOptions[indexPath.row][1];
                if (self.selectedDistanceIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.textLabel.text = self.distanceOptions[self.selectedDistanceIndex][1];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        }
        case 2: // category
            break;
        case 3: // other
            break;
    }
    
    return cell;
}
@end
