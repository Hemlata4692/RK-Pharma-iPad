//
//  LoginViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "JSON.h"
#import "UserManager.h"
#import "DejalActivityView.h"
#import "DashboardViewController.h"

int internet_connectivity_login = 0;

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize username,password,login;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Network Connection Error"
                          message:@"You need to be connected to the internet to use this feature."
                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}

- (IBAction)displayActivityView;
{
    [DejalBezelActivityView activityViewForView:self.view];
}


- (void)removeActivityView;
{
    // Remove the activity view, with animation for the two styles that support it:
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}


-(void)viewDidDisappear:(BOOL)animated
{
    internet_connectivity_login = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardDidHideNotification object:nil];

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_image_new.png"]];
    UIView *usernamepaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    username.leftView = usernamepaddingView;
    username.leftViewMode = UITextFieldViewModeAlways;
    username.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    UIView *passwordpaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    password.leftView = passwordpaddingView;
    password.leftViewMode = UITextFieldViewModeAlways;
    password.textColor= [UIColor colorWithRed:(123/255.0) green:(123/255.0) blue:(123/255.0) alpha:1];
    
    login.tintColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    responseData = [NSMutableData data];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([username isFirstResponder] && [touch view] != username)
    {
        [username resignFirstResponder];
    }
    if ([password isFirstResponder] && [touch view] != password)
    {
        [password resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(IBAction)Login_btn_clicked
{
    [username resignFirstResponder];
    [password resignFirstResponder];
    
        if ((username.text == (id)[NSNull null] || username.text.length == 0 ) ||(password.text == (id)[NSNull null] || password.text.length == 0 ))
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else 
        {
            [self displayActivityView];
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                
                //Create domain class object
                User *user=[[User alloc]init];
                user.username=username.text;//set username value in domain class
                user.password=password.text;//set password value in domain class
                
                //Create business manager class object
                UserManager *um=[[UserManager alloc]init];
                NSString* response=[um login:user];//call businessmanager login method and handle response 
                if (response.length !=0) 
                {
                    NSDictionary *var =  [response JSONValue];
                    NSLog(@"Response %@",var);
                    
                    NSString *checklogin = (NSString *)[var objectForKey:@"UserId"];
                    NSLog(@"CCC %d",[checklogin length]);
                    if([checklogin length] > 0)
                    {
                        NSString *fullname = (NSString *)[var objectForKey:@"FullName"];
                        NSString *UserId = (NSString *)[var objectForKey:@"UserId"];
                     //  NSString *UserId = @"cae9bbc2-3b5a-4f1b-9a97-f379728c26d8";
                        
                        // NSString *UserId = @"4f25cd15-42ec-4068-a629-ecd88925678a";
                         NSString *Role = (NSString *)[var objectForKey:@"RoleName"];
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:fullname  forKey:@"fullname"];
                        [defaults setObject:UserId  forKey:@"UserId"];
                        [defaults setObject:Role  forKey:@"Role"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil]; 
                        DashboardViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"leftsidebar_screen"];
                        [self presentModalViewController:rvc animated:YES];
                    }
                    else 
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                }
               
                
                [self removeActivityView];               
            });
            
            
            
            
        }
    
    
    
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"DID Receive Response");
//    [responseData setLength:0];
//}
//
//// Called when data has been received
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSLog(@"DID Receive DATA");
//    [responseData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    //NSMutableArray *responseDict1 =  [responseString2 JSONValue];
//    
//    NSMutableArray *responseDict = [[responseString JSONValue]valueForKey:@"UserId"]; 
//    NSDictionary *var =  [responseString JSONValue];
//    NSLog(@"dict %@",var);
//    
//    NSString *fullname = (NSString *)[var objectForKey:@"FullName"];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:fullname  forKey:@"fullname"];
//    
//    NSString *checklogin = (NSString *)[var objectForKey:@"UserId"];
//    NSLog(@"DID Finish Loading %@",responseDict);
//    NSLog(@"CheckLogin %@",checklogin);
//    [self removeActivityView];
//    if([checklogin length] != 0)
//    {
//        NSLog(@" NS %@",responseDict);
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil]; 
//        RKPharmaDashboardController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"leftsidebar_screen"];
//        //[self.navigationController pushViewController:rvc animated:YES];
//        
//        [self presentModalViewController:rvc animated:YES];
//    }
//    else 
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Valid Username And Password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    return TRUE;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 165; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, movement, 0);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
        [self updateFrame:CGRectMake(self.view.frame.origin.x, -165, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        
        [self animateTextField: textField up: YES];
    }

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
        [self updateFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        
        [self animateTextField: textField up: NO];
    }
}

-(void) updateFrame:(CGRect)rect{
    
    [UIView animateWithDuration:0.3f animations:^
     {
         self.view.frame=rect;
     }];
}


-(void)onKeyboardHide:(NSNotification *)notification
{
    //keyboard will hide
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
        [self updateFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        if ([password isFirstResponder]) {
            [self animateTextField: password up: NO];
            
        }
        else if ([username isFirstResponder]) {
            [self animateTextField: username up: NO];
            // [self animateTextField: password up: NO];
        }
    }
    
}



@end
