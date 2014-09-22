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
    self.candyScrollView.contentSize = self.candyView.image.size;

    self.candyView.image = self.candyImage;
    
    self.candyView.frame = CGRectMake(0, 0, self.candyView.image.size.width, self.candyView.image.size.height);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return self.candyView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
