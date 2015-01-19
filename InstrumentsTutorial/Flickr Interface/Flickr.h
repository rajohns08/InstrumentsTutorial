//
//  Flickr.h
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrPhoto;
@class FlickrSearchResults;

typedef void (^FlickrSearchCompletionBlock)(FlickrSearchResults *results, NSError *error);

@interface Flickr : NSObject

- (void)searchFlickrForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock;

@end
