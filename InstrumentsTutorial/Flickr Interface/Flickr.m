//
//  Flickr.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrSearchResults.h"

#define kFlickrAPIKey @"978d7216fb7560fbd505ddc25c7bc264"

@implementation Flickr

+ (NSString *)flickrSearchURLForSearchTerm:(NSString *)searchTerm {
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1", kFlickrAPIKey, searchTerm];
}

+ (NSURL *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *)flickrPhoto size:(NSString *)size {
    if (!size) {
        size = @"m";
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%ld/%lld_%@_%@.jpg", (long)flickrPhoto.farm, (long)flickrPhoto.server, flickrPhoto.photoID, flickrPhoto.secret, size]];
}

- (void)searchFlickrForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *searchURL = [Flickr flickrSearchURLForSearchTerm:term];
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
        if (error != nil) {
            completionBlock(nil, error);
        } else {
            // Parse the JSON Response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:kNilOptions
                                                                                error:&error];
            if (error != nil) {
                completionBlock(nil, error);
            } else {
                NSString * status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                    completionBlock(nil, error);
                } else {
                    FlickrSearchResults *searchResults = [FlickrSearchResults new];
                    searchResults.query = term;
                    
                    NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                    NSMutableArray *flickrPhotos = [@[] mutableCopy];
                    for (NSMutableDictionary *objPhoto in objPhotos) {
                        FlickrPhoto *photo = [[FlickrPhoto alloc] init];
                        photo.farm = [objPhoto[@"farm"] intValue];
                        photo.server = [objPhoto[@"server"] intValue];
                        photo.secret = objPhoto[@"secret"];
                        photo.photoID = [objPhoto[@"id"] longLongValue];
                        photo.title = objPhoto[@"title"];
                        photo.thumbnailUrl = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
                        photo.largeImageUrl = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"b"];
                        photo.searchResults = searchResults;
                        [flickrPhotos addObject:photo];
                    }
                    searchResults.results = flickrPhotos;
                    
                    completionBlock(searchResults, nil);
                }
            }
        }
    });
}

@end
