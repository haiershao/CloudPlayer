//
//  XMGPanoramaViewController.m
//  Cloud Player
//
//  Created by jiyi on 2017/8/2.
//  Copyright © 2017年 ichano. All rights reserved.
//

#import "XMGPanoramaViewController.h"
#import "CVWrapper.h"
@interface XMGPanoramaViewController ()

@end

@implementation XMGPanoramaViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self stitch];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (instancetype)panoramaViewController{
    
    return [[XMGPanoramaViewController alloc] initWithNibName:@"XMGPanoramaViewController" bundle:nil];
}

- (void) stitch
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray* imageArray = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"d1.jpg"]
                               ,[UIImage imageNamed:@"d2.jpg"]
                               ,[UIImage imageNamed:@"d3.jpg"]
                               ,[UIImage imageNamed:@"d4.jpg"]
                               ,[UIImage imageNamed:@"d5.jpg"]
                               ,[UIImage imageNamed:@"d6.jpg"]
                               ,[UIImage imageNamed:@"d7.jpg"]
                               ,[UIImage imageNamed:@"d8.jpg"]
                               ,[UIImage imageNamed:@"d9.jpg"]
                               ,nil];
        
        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog (@"stitchedImage %@",stitchedImage);
            UIImageView* imageView = [[UIImageView alloc] initWithImage:stitchedImage];
            self.imageView = imageView;
            [self.scrollView addSubview:imageView];
            self.scrollView.backgroundColor = [UIColor blackColor];
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.maximumZoomScale = 4.0;
            self.scrollView.minimumZoomScale = 0.5;
            self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
            NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;
        });
    });
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
