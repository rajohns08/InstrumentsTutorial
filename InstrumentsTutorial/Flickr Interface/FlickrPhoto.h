//
//  FlickrPhoto.h
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrSearchResults;

@interface FlickrPhoto : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *thumbnailUrl;
@property (nonatomic, strong) NSURL *largeImageUrl;
@property (nonatomic) FlickrSearchResults *searchResults;

// Lookup info
@property (nonatomic) long long photoID;
@property (nonatomic) NSInteger farm;
@property (nonatomic) NSInteger server;
@property (nonatomic, strong) NSString *secret;

@end
