//
//  QuestionViewController.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionView.h"
#import "EssayQuestionView.h"
#import "Question.h"
#import "AFNetworking.h"
#import "MultipleChoiceQuestionView.h"
#import "MoodleUrlHelper.h"
#import "ProgressHUD.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) loadView {
    self.view = [self getQuestionView];
    if (self.view == NULL) {
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        self.view = [[UIView alloc] initWithFrame:applicationFrame];
        self.view.backgroundColor = [UIColor whiteColor];
        [ProgressHUD showError:@"Unable to load question. Check your connection"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getQuestionFromServer:(UIBarButtonItem *)sender {
    [ProgressHUD show:@""];
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QuestionView *newQuestionView = [self getQuestionView];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newQuestionView) {
                [ProgressHUD dismiss];
                self.view = newQuestionView;
            } else {
                [ProgressHUD showError:@"Unable to load question. Check your connection"];
            }
        });
    });*/
    QuestionView *newQuestionView = [self getQuestionView];
    if (newQuestionView) {
        self.view = newQuestionView;
        [ProgressHUD dismiss];
    } else {
        [ProgressHUD showError:@"Unable to load question. Check your connection"];
    }
}

- (QuestionView *)getQuestionView {
    QuestionView *questionView = NULL;
    NSString *questionUrl = [MoodleUrlHelper getSubmitUrlWithPasscode:self.passcode];
    NSLog(@"Loading question from url %@", questionUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:questionUrl]];
    if (data) {
        [ProgressHUD dismiss];
        Question *question = [QuestionFactory createNewQuestionWithData:data];
        question.passcode = self.passcode;
        questionView = [self createQuestionViewFromQuestion:question];
        NSLog(@"Question Loaded: \n %@", question);
        questionView.question = question;
        self.view = questionView;
    }
    return questionView;
}

- (QuestionView *)createQuestionViewFromQuestion:(Question *)question {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect questionViewFrame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height);
    if ([question.type isEqualToString:MULTIPLE_CHOICE]) {
        return [[MultipleChoiceQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else if ([question.type isEqualToString:ESSAY]) {
        return [[EssayQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else {
        return [[QuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    }
}

@end
