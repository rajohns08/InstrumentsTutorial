//
//  BookCell.m
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 05/08/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "PhotoCell.h"

#import "FlickrPhoto.h"
#import "ImageCache.h"

@interface PhotoCell ()
@end

@implementation PhotoCell

- (void)setPhoto:(FlickrPhoto *)photo {
    _photo = photo;
    
    self.textLabel.text = photo.title;
    
//    NSData *imageData = [NSData dataWithContentsOfURL:_photo.thumbnailUrl];
//    self.imageView.image = [UIImage imageWithData:imageData];
    
    
    [[ImageCache sharedInstance] downloadImageAtURL:_photo.thumbnailUrl
                                  completionHandler:^(UIImage *image) {
                                      self.imageView.image = image;
                                      [self setNeedsLayout];
                                  }];
    
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    }
    return self;
}

@end
