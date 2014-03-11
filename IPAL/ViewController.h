//
//  ViewController.h
//  IPAL
//
//  Created by Tarun Verghis on 3/9/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController
- (IBAction)loginButtonPressed:(id)sender;
- (void)showPasscodeAlert;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
