//
//  BookCell.h
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 05/08/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;

@interface PhotoCell : UITableViewCell

@property (nonatomic, strong) FlickrPhoto *photo;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
