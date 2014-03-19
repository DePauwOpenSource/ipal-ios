//
//  QuestionViewController.h
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "QuestionFactory.h"

@interface QuestionViewController : UIViewController

@property (strong, nonatomic) Question *question;
@property int passcode;

@end
