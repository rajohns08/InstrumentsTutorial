//
//  SearchResultsViewController.h
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 09/06/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrSearchResults;

@interface SearchResultsViewController : UITableViewController

- (id)initWithSearchResults:(FlickrSearchResults*)results;

@end
