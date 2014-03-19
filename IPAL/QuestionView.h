//
//  QuestionView.h
//  IPAL
//
//  Created by Ngoc Nguyen on 3/18/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
@interface QuestionView : UIView <UITextViewDelegate>

/*
 * Inits UI elements her
 */
-(void) initElements;

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) UILabel *questionText;
@property (strong, nonatomic) UIButton *submitButton;

@end
