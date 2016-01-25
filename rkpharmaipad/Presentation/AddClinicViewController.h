//
//  AddClinicViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 09/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
@class DashboardViewController;
DashboardViewController *dashboardcontroller;

@interface AddClinicViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,ALPickerViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *date_label;
    IBOutlet UIButton *submit_button,*clinic_button,*location_button,*back;
    IBOutlet UIPickerView *location_picker;
    NSMutableArray *location_array,*clinic_array;
    ALPickerView *clinic_picker;
    UIToolbar *location_picker_toolbar;
    NSArray *entries;
	NSMutableDictionary *selectionStates;
}
@property(nonatomic,retain)UILabel *date_label;
@property(nonatomic,retain)UIToolbar *location_picker_toolbar;
@property(nonatomic,retain)UIButton *submit_button,*clinic_button,*location_button,*back;
@property(nonatomic,retain)UIPickerView *location_picker;

-(IBAction)Get_Location;
-(IBAction)Submit:(id)sender;
-(IBAction)backbtn_clicked;

@end