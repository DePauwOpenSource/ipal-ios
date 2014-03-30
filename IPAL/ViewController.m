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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Clear username and password fields
    [_passwordField setText:@""];
    //Populate url from NSUserDefaults
    self.urlField.text = [UserPreferences getUrl];
    self.usernameField.text = [UserPreferences getUsername];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSString *urlText = self.urlField.text;
    //saving moodle url in NSUserDefault
    if (![MoodleUrlHelper isValidUrl:urlText]) {
        NSLog(@"URL is invalid");
        UIAlertView *loginFailedAlert = [[UIAlertView alloc] initWithTitle:@"Invalid URL"
                                                                   message:@"Please check your url again."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
        [loginFailedAlert show];
        return;
    } else {
        NSLog(@"URL is valid");
    }
    [UserPreferences saveUrl:urlText];
    NSArray *possibleUrls = [MoodleUrlHelper getPossibleUrls:urlText];
    NSLog(@"Possible Urls: %@", possibleUrls);
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [UserPreferences saveUsername:username];
    for (NSString *url in possibleUrls) {
        NSString *loginUrl = [url stringByAppendingString:@"login/index.php"];
        NSLog(@"Attempting to log in with url %@...", loginUrl);
        
        //Clear existing cookies
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:loginUrl]];
        for (NSHTTPCookie *cookie in cookies)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            NSLog(@"Cookies cleared.");
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters = @{@"username": username, @"password": password};
        [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Sample logic to check login status
            if ([operation.responseString rangeOfString:@"You are logged in as"].location == NSNotFound) {
                NSLog(@"Log in failed: Username/password mismatch.");
                UIAlertView *loginFailedAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                                           message:@"Username and password did not match."
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Ok"
                                                                 otherButtonTitles:nil];
                [loginFailedAlert show];
            } else {
                NSLog(@"Login succeeded.");
                //Popup modal with textfield
                [self showPasscodeAlert];
                
                //[self performSegueWithIdentifier:@"PushMCQView" sender:sender];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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
    
    passcodeAlert.cancelButtonIndex = -1;
    
    [passcodeAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *expectedPasscode = @"123"; //TODO: Get actual passcode
    
    if (buttonIndex == 1) {
        NSString *passcode = [alertView textFieldAtIndex:0].text;
        NSLog(@"Got passcode: %@", passcode);
        if([passcode isEqualToString:expectedPasscode])
        {
            NSLog(@"Matching passcodes.");
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
            [self performSegueWithIdentifier:@"PushQuestionView" sender:self];
        }
        else{
            NSLog(@"Passcodes mismatch: %@ / %@", passcode, expectedPasscode);
            UIAlertView *passcodeFailed = [[UIAlertView alloc] initWithTitle:@"Passcode Failed"
                                                                       message:@"Please ensure that you enter the most up-to-date passcode for the poll."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"Ok"
                                                             otherButtonTitles:nil];
            [passcodeFailed show];
        }
    }
}

@end
