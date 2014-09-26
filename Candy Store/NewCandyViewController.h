//
//  NewCandyViewController.h
//  Candy Store
//
//  Created by Jiahe Kuang on 9/17/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Candy;

@interface NewCandyViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Candy *candy;

@end
