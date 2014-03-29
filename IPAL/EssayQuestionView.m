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

#define FONT_SIZE 12.0f
#define TEXTVIEW_HORIZONTAL_PAD 10
#define TEXTVIEW_VERTICAL_PAD 10

- (void) initElements {
    //TODO: Improve the look and dynamic sizing of frame
    [super initElements];
    CGRect textViewFrame = CGRectMake(TEXTVIEW_HORIZONTAL_PAD, self.questionText.frame.origin.y + self.questionText.frame.size.height + TEXTVIEW_VERTICAL_PAD,
                              self.bounds.size.width - 2*TEXTVIEW_HORIZONTAL_PAD, self.frame.size.height - self.questionText.frame.origin.y - self.questionText.bounds.size.height - self.submitButton.bounds.size.height);
    self.answerText = [[UITextView alloc] initWithFrame:textViewFrame];
    [self.answerText setText:@"Answer here"];
    [self addSubview:self.answerText];
    [self.answerText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.answerText.layer setBorderWidth:0.7f];
    
    //Rounded corner border for answer text view
    self.answerText.layer.cornerRadius = 5;
    self.answerText.clipsToBounds = YES;
    
    self.answerText.font = [UIFont systemFontOfSize:12];
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
