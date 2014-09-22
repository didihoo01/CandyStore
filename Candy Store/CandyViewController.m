//
//  CandyViewController.m
//  Candy Store
//
//  Created by Jiahe Kuang on 9/17/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import "CandyViewController.h"
#import "Candy.h"
#import "CandyScrollViewController.h"
#import "CandyMapViewController.h"

@interface CandyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *candyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *locationField;


@end

@implementation CandyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameField.text = self.candy.name;
    self.locationField.text = self.candy.location;
    self.candyImageView.image = [UIImage imageWithData:self.candy.candyImage] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] ==  _candyImageView)
    {
        //add your code for image touch here
        [self performSegueWithIdentifier: @"CandyScrollView" sender: self];

    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    if ([segue.identifier isEqualToString:@"CandyScrollView"])
    {
        
        CandyScrollViewController* candyScrollViewController = [segue destinationViewController];
        candyScrollViewController.candyImage = [UIImage imageWithData:self.candy.candyImage];
    }
    
    if ([segue.identifier isEqualToString:@"CandyMapView"])
    {
        CandyMapViewController* candyMapViewController = [segue destinationViewController];
        candyMapViewController.candyLocation = self.candy.location;
    }

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
