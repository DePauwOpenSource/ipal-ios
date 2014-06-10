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

@property (weak, atomic) QuestionView *questionView;

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    //actually load the current question from the passcode
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.questionView = [self createQuestionViewFromQuestion:[QuestionFactory emptyQuestion]];
    [self.view addSubview:self.questionView];
    [self loadQuestionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getQuestionFromServer:(UIBarButtonItem *)sender {
    [self loadQuestionView];
}

- (void) loadQuestionView {
    [ProgressHUD show:@"Loading question"];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSString *questionUrl = [MoodleUrlHelper getQuestionUrlWithPasscode:self.passcode];
         NSLog(@"Loading question from url %@", questionUrl);
         NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:questionUrl]];
         dispatch_async(dispatch_get_main_queue(), ^{
             if (data) {
                 Question *question = [QuestionFactory createNewQuestionWithData:data];
                 NSLog(@"Question Loaded: \n %@", question);
                 question.passcode = self.passcode;
                 if (self.questionView){
                     [self.questionView removeFromSuperview];
                 }
                 QuestionView *newView = [self createQuestionViewFromQuestion:question];
                 self.questionView = newView;
                 //self.questionView = [self createQuestionViewFromQuestion:question];
                 [self.view addSubview:self.questionView];
                 [ProgressHUD dismiss];
             } else {
                 NSLog(@"Unable to load question");
                 [ProgressHUD showError:@"Unable to load question. Check your connection"];
             }
         });
     });
}

- (QuestionView *)getQuestionView {
    QuestionView *questionView = NULL;
    NSString *questionUrl = [MoodleUrlHelper getQuestionUrlWithPasscode:self.passcode];
    NSLog(@"Loading question from url %@", questionUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:questionUrl]];
    if (data) {
        [ProgressHUD dismiss];
        Question *question = [QuestionFactory createNewQuestionWithData:data];
        question.passcode = self.passcode;
        questionView = [self createQuestionViewFromQuestion:question];
        NSLog(@"Question Loaded: \n %@", question);
        questionView.question = question;
        //self.view = questionView;
    }
    return questionView;
}

- (QuestionView *)createQuestionViewFromQuestion:(Question *)question {
    //CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //CGRect questionViewFrame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height);
    CGRect questionViewFrame = self.view.bounds;
    if ([question.type isEqualToString:MULTIPLE_CHOICE]) {
        return [[MultipleChoiceQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else if ([question.type isEqualToString:ESSAY]) {
        return [[EssayQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else {
        return [[QuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    }
}

@end
