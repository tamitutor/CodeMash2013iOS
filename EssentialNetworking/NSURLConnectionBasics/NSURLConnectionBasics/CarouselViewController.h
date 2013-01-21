//
//  CarouselViewController.h
//  NSURLConnectionBasics
//
//  Created by Steve Madsen on 7/31/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselViewController : UIViewController
    <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property IBOutlet UIImageView *imageView;
@property IBOutlet UIActivityIndicatorView *activityIndicator;

@end
