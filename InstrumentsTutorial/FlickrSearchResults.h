//
//  FlickrSearchResults.h
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 04/09/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrSearchResults : NSObject

@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) NSArray *results;

@end
