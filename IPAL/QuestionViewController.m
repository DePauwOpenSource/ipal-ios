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
#import "UserPreferences.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) loadView {
    [self loadQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getQuestionFromServer:(UIBarButtonItem *)sender {
    [self loadQuestion];
}

- (void)loadQuestion {
    NSString *moodleUrl = [UserPreferences getUrl];
    NSString *username = [UserPreferences getUsername];
    NSString *questionUrl = [NSString stringWithFormat:@"%@/mod/ipal/tempview.php?p=%d&user=%@", moodleUrl, self.passcode, username];
    NSLog(@"Loading question from url %@", questionUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:questionUrl]];
    Question *question = [QuestionFactory createNewQuestionWithData:data];
    QuestionView *questionView = [self getQuestionViewFromQuestion:question];
    NSLog(@"Question Loaded: \n %@", question);
    questionView.question = question;
    self.view = questionView;
}

- (QuestionView *)getQuestionViewFromQuestion:(Question *)question {
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
