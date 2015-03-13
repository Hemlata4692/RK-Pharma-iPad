//
//  CallSummaryViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 10/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
//@class DashboardViewController;
//DashboardViewController *dashboardcontroller;
//@interface CallSummaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//{
//    IBOutlet UITableView *product_table;
//    IBOutlet UIDatePicker *date_picker;
//    NSMutableArray *product_array;
//    IBOutlet UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label;
//    IBOutlet UIButton *date_button,*post_radio,*current_radio;
//    IBOutlet UITextView *order_textview,*remarks_textview;
//    BOOL checkBoxSelected;
//    IBOutlet NSString *plan_id,*location_string,*clinicname_string;
//    IBOutlet UITextField *quantity,*samplechitno;
//}
//@property(nonatomic,retain)UITableView *product_table;
//@property(nonatomic,retain)UIDatePicker *date_picker;
//@property(nonatomic,retain)UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label;
//@property(nonatomic,retain)UIButton *date_button,*post_radio,*current_radio;
//@property(nonatomic,retain)UITextView *order_textview,*remarks_textview;
//@property(nonatomic,retain)NSString *plan_id,*location_string,*clinicname_string;
//@property(nonatomic,retain) UITextField *quantity,*samplechitno;
//
//-(IBAction)togglecall;
//-(IBAction)GetDate;
//-(IBAction)SubmitCallSummary;
//@end


//
//  CallSummaryViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 10/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"

@class DashboardViewController,DailyPlanReportViewController,DailyPlanListViewController,DailyClinicPlannedViewController;
DashboardViewController *dashboardcontroller;
DailyPlanReportViewController *dailyplanreportcontroller;
DailyPlanListViewController *dailyplanlistcontroller;
DailyClinicPlannedViewController *plannedcliniccontroller;
@interface CallSummaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ALPickerViewDelegate>
{
    IBOutlet UITableView *product_table;
    IBOutlet UIDatePicker *date_picker;
    NSMutableArray *product_array,*assignedproduct_array;
    IBOutlet UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label,*plan_date;
    IBOutlet UIButton *date_button,*post_radio,*current_radio,*call_assistant,*back,*product_button;
    IBOutlet UITextView *order_textview,*remarks_textview;
    BOOL checkBoxSelected;
    BOOL radioBoxSelected;
    IBOutlet NSString *plan_id,*location_string,*clinicname_string;
    IBOutlet UITextField *quantity,*samplechitno;
    NSMutableArray *total_value;
    
    ALPickerView *product_picker;
    UIToolbar *product_picker_toolbar,*date_picker_toolbar;
    NSArray *entries;
	NSMutableDictionary *selectionStates;
}
@property(nonatomic,retain)UITableView *product_table;
@property(nonatomic,retain)UIDatePicker *date_picker;
@property(nonatomic,retain) UIToolbar *product_picker_toolbar,*date_picker_toolbar;
@property(nonatomic,retain)UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label,*plan_date;
@property(nonatomic,retain)UIButton *date_button,*post_radio,*current_radio,*call_assistant,*back,*product_button;
@property(nonatomic,retain)UITextView *order_textview,*remarks_textview;
@property(nonatomic,retain)NSString *plan_id,*location_string,*clinicname_string;
@property(nonatomic,retain) UITextField *quantity,*samplechitno;

-(IBAction)togglecall;
-(IBAction)toggleassistant;
-(IBAction)GetDate;
-(IBAction)SubmitCallSummary;
-(void)PassValue:(NSDictionary *)dict;
-(IBAction)backbtn_clicked;
-(IBAction)Get_Product;
@end

