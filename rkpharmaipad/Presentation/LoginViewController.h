//
//  LoginViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *username,*password;
    IBOutlet UIButton *login;
    NSMutableData *responseData;
}
@property(nonatomic,retain)UITextField *username,*password;
@property(nonatomic,retain)UIButton *login;

//Called login method
-(IBAction)Login_btn_clicked;
@end
