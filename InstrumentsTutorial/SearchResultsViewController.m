//
//  SearchResultsViewController.m
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 09/06/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "PhotoCell.h"
#import "FlickrSearchResults.h"
#import "FlickrPhoto.h"
#import "ViewImageViewController.h"

@interface SearchResultsViewController () <ViewImageViewControllerDelegate>
@property (nonatomic, strong) FlickrSearchResults *searchResults;
@property (nonatomic, strong) ViewImageViewController *viewImageViewController;
@end

@implementation SearchResultsViewController

#pragma mark -

- (id)initWithSearchResults:(FlickrSearchResults *)results {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.searchResults = results;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.searchResults.query;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PhotoCell *cell = (PhotoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhotoCell alloc] initWithReuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    FlickrPhoto *photo = self.searchResults.results[indexPath.row];
    cell.photo = photo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_viewImageViewController) {
        self.viewImageViewController = [[ViewImageViewController alloc] init];
        _viewImageViewController.delegate = self;
    }
    
    FlickrPhoto *photo = self.searchResults.results[indexPath.row];
    _viewImageViewController.photo = photo;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_viewImageViewController];
    [self presentModalViewController:navController animated:YES];
}


#pragma mark - ViewImageViewControllerDelegate

- (void)viewImageViewControllerDidFinish:(ViewImageViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
