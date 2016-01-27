//
//  CallCardViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 13/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardViewController,ClinicListViewController,ClinicDetailViewController;
DashboardViewController *dashboardcontroller;
ClinicListViewController *cliniclistcontroller;
ClinicDetailViewController *clinicdetailcontroller;
@interface CallCardViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *callcard_table;
    NSMutableData *responseData;
    NSMutableArray *callcard_array,*location_array,*clinic_array,*division_array;
    UIToolbar *location_picker_toolbar,*clinic_picker_toolbar,*division_picker_toolbar;
    IBOutlet UILabel *date,*products,*sample,*order,*error,*bonus,*unofficialbonus,*clinicname_label,*clinicaddress_label;
    IBOutlet UIButton *clinic_button,*location_button,*division_button,*backbutton,*search,*issuedby_company;
    IBOutlet UIPickerView *location_picker,*clinic_picker,*division_picker;
    IBOutlet UITextView *remarks;
    IBOutlet UIImageView *backarrow;
    BOOL checkBoxSelected;
    
}
@property(nonatomic,retain)UITableView *callcard_table;
@property(nonatomic,retain)UIImageView *backarrow;
@property(nonatomic,retain)UIToolbar *location_picker_toolbar,*clinic_picker_toolbar,*division_picker_toolbar;
@property(nonatomic,retain)UILabel *date,*products,*sample,*order,*error,*bonus,*unofficialbonus,*clinicname_label,*clinicaddress_label;
@property(nonatomic,retain)UIButton *clinic_button,*location_button,*division_button,*backbutton,*search,*issuedby_company;
@property(nonatomic,retain)UIPickerView *location_picker,*clinic_picker,*division_picker;
@property(nonatomic,retain)UITextView *remarks;

-(IBAction)GetClinics;
-(IBAction)SearchCallcard;
-(IBAction)Get_Location;
-(void)PassValue:(NSDictionary *)dict;
-(IBAction)backbtn_clicked;
@end
