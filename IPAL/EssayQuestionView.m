//
//  EssayQuestionView.m
//  IPAL
//
//  Created by Ngoc Nguyen on 3/18/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "EssayQuestionView.h"
#import "EssayQuestion.h"

@interface EssayQuestionView()

@property (strong, nonatomic) UITextView *answerText;

@end

@implementation EssayQuestionView


- (void) initElements {
    //TODO: Improve the look and dynamic sizing of frame
    [super initElements];
    CGRect textViewFrame = CGRectMake(0, 150, self.bounds.size.width, 200);
    _answerText = [[UITextView alloc] initWithFrame:textViewFrame];
    [self.answerText setText:@"Answer here"];
    [self addSubview:self.answerText];
    self.answerText.layer.borderWidth = 1.0f;
    self.answerText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.answerText.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.answerText.font = [UIFont boldSystemFontOfSize:12];
    self.answerText.backgroundColor = [UIColor whiteColor];
    self.answerText.scrollEnabled = YES;
    self.answerText.pagingEnabled = YES;
    self.answerText.editable = YES;
    self.answerText.delegate = self;
    //[self.answerText becomeFirstResponder];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Answer here"]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //casting here is safe because we are in the EssayQuestionView
    ((EssayQuestion *)self.question).answer = self.answerText.text;
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
