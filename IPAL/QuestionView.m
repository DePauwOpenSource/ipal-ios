//
//  QuestionView.m
//  IPAL
//
//  Created by Ngoc Nguyen on 3/18/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionView.h"
#import "AFNetworking.h"
#import "MoodleUrlHelper.h"
#import "ProgressHUD.h"

@implementation QuestionView

-(id) initWithFrame:(CGRect)frame withQuestion:(Question *)question {
    self = [super initWithFrame:frame];
    if (self) {
        self.question = question;
        [self initElements];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder withQuestion:(Question *)question {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.question = question;
        [self initElements];
    }
    return self;
}

#define FONT_SIZE 14.0f
#define QUESTION_LABEL_HORIZONTAL_PAD 10
#define QUESTION_LABEL_VERTICAL_PAD 10
#define Y_AFTER_NAV_BAR 75
#define SUBMIT_BUTTON_HEIGHT 40


-(void) initElements {
    self.backgroundColor = [UIColor whiteColor];
    
    //Initalize question label with a zero frame. Set the attributedText.
    self.questionText = [[UILabel alloc] initWithFrame:CGRectZero];
    NSAttributedString *text = [self getAttributedQuestionText];

    self.questionText.attributedText = text;
    self.questionText.numberOfLines = 0;
    [self addSubview:self.questionText];
    
    //resize the question label frame to fit the text length dynamically
    CGSize labelSize = CGSizeZero;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width -2 *QUESTION_LABEL_HORIZONTAL_PAD, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    labelSize = boundingRect.size;
    self.questionText.frame = CGRectMake(QUESTION_LABEL_HORIZONTAL_PAD,
                                         Y_AFTER_NAV_BAR + QUESTION_LABEL_VERTICAL_PAD,
                             self.frame.size.width - 2*QUESTION_LABEL_HORIZONTAL_PAD, ceilf(labelSize.height));
    //Submit button
    CGRect buttonFrame = CGRectMake(QUESTION_LABEL_HORIZONTAL_PAD, self.frame.origin.y + self.frame.size.height - SUBMIT_BUTTON_HEIGHT , self.frame.size.width, SUBMIT_BUTTON_HEIGHT);
    _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitButton.frame = buttonFrame;
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self
               action:@selector(submitQuestion)
     forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [self addSubview:self.submitButton];
}

-(NSAttributedString *) getAttributedQuestionText {
    if (!self.question) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *questionText = [[NSMutableAttributedString alloc] initWithString:self.question.text];
    [questionText setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, questionText.length)];
    [questionText setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, questionText.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [questionText setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, questionText.length)];
    
    [questionText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FONT_SIZE]} range: NSMakeRange(0, questionText.length)];
    return questionText;

}
-(void)submitQuestion {
    NSLog(@"Submitting question...");
    [ProgressHUD show:@"Submitting question"];
    NSDictionary *parameters = [self.question getParametersForSubmission];
    NSString *urlString = [MoodleUrlHelper getSubmitUrlWithPasscode:self.question.passcode];
    NSLog(@"URL: %@", urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"params: %@", parameters);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD showSuccess:@"Question Submitted"];
        NSLog(@"Question Submitted");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [ProgressHUD showError:@"Question not submitted! Please try again."];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //Minimize the keyboard when the "return" key is pressed
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
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
