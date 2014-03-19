//
//  QuestionView.m
//  IPAL
//
//  Created by Ngoc Nguyen on 3/18/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionView.h"
#import "AFNetworking.h"

@implementation QuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [self initElements];
    }
    return self;
}

-(void)setQuestion:(Question *)question {
    _question = question;
    [self refresh];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initElements];
    }
    return self;
}

-(void) initElements {
    //TODO: better layout, auto resizing
    self.backgroundColor = [UIColor whiteColor];
    NSLog(@"here");
    CGRect labelFrame = CGRectMake(5, 70, self.bounds.size.width, 80);
    _questionText = [[UILabel alloc] initWithFrame:labelFrame];
    [self.questionText setText:@"Question Text"];
    //self.questionText.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionText.numberOfLines = 0;
    self.questionText.adjustsFontSizeToFitWidth = YES;
    
    //resize the Label based on the text lengh
    //[self.questionText sizeToFit];
    [self addSubview:self.questionText];
    
    CGRect buttonFrame = CGRectMake(5, 400, 320, 40);
    _submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitButton.frame = buttonFrame;
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self
               action:@selector(submitQuestion)
     forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [self addSubview:self.submitButton];
    
    [self refresh];
}

-(void)submitQuestion {
    NSLog(@"Submitting question...");
    //add code to submit question
    NSDictionary *parameters = [self.question getParametersForSubmission];
    NSString *urlString = @"http://54.218.0.148/moodle/mod/ipal/tempview.php?p=125&user=user";
    //NSLog([NSString stringWithFormat:@"params: %@", parameters]);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Question Submitted"
                                                               message:@"Your answer is submitted successfully"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
        [successAlert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog([NSString stringWithFormat:@"Error: %@", error]);
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Question Submitted Failed"
                                                               message:@"Your answer is not submitted. Please try again!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
        [failAlert show];
    }];
    NSLog(@"Question submitted...");
}

-(void) refresh {
    [self.questionText setText:self.question.text];
}

-(NSString *) getAnswerValue {
    return @"";
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
