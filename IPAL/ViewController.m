//
//  ViewController.m
//  IPAL
//
//  Created by Tarun Verghis on 3/9/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "ViewController.h"
#import "MoodleUrlHelper.h"
#import "UserPreferences.h"
#import "QuestionViewController.h"
#import "ProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property int passcode;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passcode = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    //Clear username and password fields
    [_passwordField setText:@""];
    //Populate url from NSUserDefaults
    self.urlField.text = [UserPreferences getUrl];
    self.usernameField.text = [UserPreferences getUsername];
    self.passwordField.text = @"bitnami";
    
    //Show an "x" to clear text in the text field
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.urlField.clearButtonMode = UITextFieldViewModeWhileEditing;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    [ProgressHUD show:@"Logging in"];
    
    // minimize keyboard
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.urlField resignFirstResponder];
    
    NSString *urlText = self.urlField.text;
    NSString *username = self.usernameField.text;
    if (username.length == 0) {
        [ProgressHUD showError:@"Please enter your username"];
        return;
    }
    NSString *password = self.passwordField.text;
    if (password.length == 0) {
        [ProgressHUD showError:@"Please enter your password"];
        return;
    }
    [UserPreferences saveUsername:username];
    if (urlText.length == 0) {
        [ProgressHUD showError:@"Please enter your Moodle URL!"];
        return;
    }
    [UserPreferences saveUrl:urlText];
    
    NSArray *possibleUrls = [MoodleUrlHelper getPossibleUrls:urlText];
    NSLog(@"Possible Urls: %@", possibleUrls);
    if ([possibleUrls count] == 0) {
        NSLog(@"URL is invalid");
        [ProgressHUD showError:@"Your URL is invalid"];
        return;
    }
    
    
    __block bool success = false;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //run only one connection at once, so we run http url and https url connection
    //one after another.
    [manager.operationQueue setMaxConcurrentOperationCount:1];
    
    for (int i=0; i< [possibleUrls count]; i++) {
        NSString *url = [possibleUrls objectAtIndex:i];
        NSString *loginUrl = [url stringByAppendingString:@"login/index.php"];
        NSLog(@"Attempting to log in with url %@...", loginUrl);
        
        //Clear existing cookies
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:loginUrl]];
        for (NSHTTPCookie *cookie in cookies)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            NSLog(@"Cookies cleared.");
        }
        
        NSDictionary *parameters = @{@"username": username, @"password": password};
        [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Sample logic to check login status
            if ([operation.responseString rangeOfString:@"You are logged in as"].location == NSNotFound) {
                NSLog(@"Log in failed: Username/password mismatch.");
                [ProgressHUD showError:@"Login failed. Please check your username and password"];
            } else {
                //suspend all other connections
                [manager.operationQueue setSuspended:true];
                [ProgressHUD dismiss];
                success = true;
                NSLog(@"Login succeeded.");
                //Popup modal with textfield
                [UserPreferences saveUrl:url];
                                [self showPasscodeAlert];
                //[self performSegueWithIdentifier:@"PushMCQView" sender:sender];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"login failed with url %@", url);
            if (i == [possibleUrls count]-1 && !success) {
                //show error if the last connection failed and no previous connections succeed.
                [ProgressHUD showError:@"Login failed. Check your Moodle URL!"];
            }
        }];
    }
    //NSString *loginUrl = [urlText stringByAppendingString:@"login/index.php"];
    //NSString *urlString = @"http://54.218.0.148/moodle/login/index.php";
}

- (void)showPasscodeAlert
{
    NSLog(@"Showing passcode alert.");
    UIAlertView *passcodeAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter the passcode provided to you by your instructor" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    
    passcodeAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[passcodeAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [passcodeAlert textFieldAtIndex:0 ].clearButtonMode = UITextFieldViewModeWhileEditing;

    passcodeAlert.cancelButtonIndex = -1;
    
    [passcodeAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *passcodeString = [alertView textFieldAtIndex:0].text;
        NSLog(@"Got passcode: %@", passcodeString);
        self.passcode = [passcodeString intValue];
        if (self.passcode == 0) {
            [ProgressHUD showError:@"Invalid Passcode. Please see the Intructor!"];
        } else {
            [ProgressHUD show:@"Loading Question"];
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            [self performSegueWithIdentifier:@"PushQuestionView" sender:self];
            [ProgressHUD dismiss];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PushQuestionView"])
    {
        NSLog(@"Preparing for question view controller");
        NSLog(@"Setting passcode to %d", self.passcode);
        QuestionViewController *destViewController = segue.destinationViewController;
        destViewController.passcode = self.passcode;
    }
}

@end
