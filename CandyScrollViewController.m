//
//  CandyScrollViewController.m
//  Candy Store
//
//  Created by Jiahe Kuang on 9/20/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import "CandyScrollViewController.h"

@interface CandyScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *candyScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *candyView;


@end

@implementation CandyScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.candyScrollView.delegate = self;
//    self.candyScrollView.contentSize = self.candyView.image.size;

//    self.candyView.image = self.candyImage;

}

- (void)viewDidLayoutSubviews
{
    self.candyView.bounds = CGRectMake(0, 0, self.candyImage.size.width, self.candyImage.size.height);

    self.candyScrollView.contentSize = self.candyView.bounds.size;
    
    self.candyView.image = self.candyImage;

}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return self.candyView;
}


@end
