//
//  ViewController.m
//  IPAL
//
//  Created by Tarun Verghis on 3/9/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    //Clear username and password fields
    [_usernameField setText:@""];
    [_passwordField setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSString *urlString = @"http://54.218.0.148/moodle/login/index.php";
    //Clear existing cookies
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlString]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        NSLog(@"Cookies cleared.");
    }
    
    NSLog(@"Attempting to log in...");
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"username": username, @"password": password};
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
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
