//
//  ViewImageViewController.m
//  InstrumentsTutorial
//
//  Created by Matt Galloway on 06/09/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "ViewImageViewController.h"

#import "FlickrPhoto.h"
#import "ImageCache.h"

@interface ViewImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation ViewImageViewController

- (void)doneTapped:(id)sender {
    [_delegate viewImageViewControllerDidFinish:self];
}

- (void)rotateTapped:(id)sender {
    UIImage *currentImage = _imageView.image;
    CGImageRef currentCGImage = currentImage.CGImage;
    
    CGSize originalSize = currentImage.size;
    CGSize rotatedSize = CGSizeMake(originalSize.height, originalSize.width);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 rotatedSize.width,
                                                 rotatedSize.height,
                                                 CGImageGetBitsPerComponent(currentCGImage),
                                                 CGImageGetBitsPerPixel(currentCGImage) * rotatedSize.width,
                                                 CGImageGetColorSpace(currentCGImage),
                                                 CGImageGetBitmapInfo(currentCGImage));
    
    CGContextTranslateCTM(context, rotatedSize.width, 0.0f);
    CGContextRotateCTM(context, M_PI_2);
    CGContextDrawImage(context, (CGRect){.origin=CGPointZero, .size=originalSize}, currentCGImage);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    
    self.imageView.image = newImage;
    
    CGImageRelease(newCGImage);
    CGContextRelease(context);
}

- (void)setPhoto:(FlickrPhoto *)photo {
    _photo = photo;
    self.title = self.photo.title;
    [_activityView startAnimating];
    _imageView.image = nil;
    [[ImageCache sharedInstance] downloadImageAtURL:photo.largeImageUrl
                                  completionHandler:^(UIImage *image) {
                                      _imageView.image = image;
                                      [_activityView stopAnimating];
                                  }];
}

- (id)init {
    if ((self = [super initWithNibName:nil bundle:nil])) {
    }
    return self;
}

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityView.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
    [self.view addSubview:_activityView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Rotate" style:UIBarButtonItemStyleBordered target:self action:@selector(rotateTapped:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
