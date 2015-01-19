//
//  ImageCache.h
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 06/09/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageCacheDownloadCompletionHandler)(UIImage *image);

@interface ImageCache : NSObject

+ (id)sharedInstance;

- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)image forKey:(NSString*)key;
- (void)downloadImageAtURL:(NSURL*)url completionHandler:(ImageCacheDownloadCompletionHandler)completion;

@end
