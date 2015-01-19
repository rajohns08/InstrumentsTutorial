//
//  ViewImageViewController.h
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 06/09/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewImageViewController;
@class FlickrPhoto;

@protocol ViewImageViewControllerDelegate <NSObject>
- (void)viewImageViewControllerDidFinish:(ViewImageViewController*)viewController;
@end

@interface ViewImageViewController : UIViewController

@property (nonatomic, strong) FlickrPhoto *photo;
@property (nonatomic, weak) id <ViewImageViewControllerDelegate> delegate;

@end
