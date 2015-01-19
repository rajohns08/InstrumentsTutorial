//
//  HomeViewController.m
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 09/06/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "HomeViewController.h"

#import "Flickr.h"
#import "FlickrSearchResults.h"
#import "SearchResultsViewController.h"

@interface HomeViewController () <UISearchBarDelegate> {
    Flickr *_flickr;
    NSMutableArray *_searches;
}

@end

@implementation HomeViewController

#pragma mark -

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _flickr = [Flickr new];
        _searches = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Flickr Search";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    FlickrSearchResults *search = _searches[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%lu)", search.query, (unsigned long)search.results.count];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_searches removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FlickrSearchResults *search = _searches[indexPath.row];
    SearchResultsViewController *viewController = [[SearchResultsViewController alloc] initWithSearchResults:search];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_flickr searchFlickrForTerm:searchBar.text completionBlock:^(FlickrSearchResults *results, NSError *error) {
        if (!error) {
            [_searches addObject:results];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_searches.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            });
        }
    }];
    [searchBar resignFirstResponder];
}

@end
