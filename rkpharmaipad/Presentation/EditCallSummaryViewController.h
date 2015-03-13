//
//  EditCallSummaryViewController.h
//  RKPharma
//
//  Created by Shivendra on 06/06/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
@class DailyPlanReportViewController;
DailyPlanReportViewController *dailyplanreportcontroller;
@interface EditCallSummaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ALPickerViewDelegate>
{
    IBOutlet UITableView *product_table;
    IBOutlet UIDatePicker *date_picker;
    NSMutableArray *product_array,*sample_array,*assignedproduct_array;
    IBOutlet UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label,*plan_date,*chitno;
    IBOutlet UIButton *date_button,*post_radio,*current_radio,*call_assistant,*back,*product_button;
    IBOutlet UITextView *order_textview,*remarks_textview;
    BOOL checkBoxSelected;
    BOOL radioBoxSelected;
    IBOutlet NSString *plan_id,*location_string,*clinicname_string,*summary_id;
    IBOutlet UITextField *quantity,*samplechitno;
    NSMutableArray *total_value,*editproduct_array;
    
    ALPickerView *product_picker;
    NSArray *entries;
	NSMutableDictionary *selectionStates;
}
@property(nonatomic,retain)UITableView *product_table;
@property(nonatomic,retain)UIDatePicker *date_picker;
@property(nonatomic,retain)UILabel *clinic_name,*product_name,*available_quantity,*expiry_date,*location_label,*plan_date,*chitno;
@property(nonatomic,retain)UIButton *date_button,*post_radio,*current_radio,*call_assistant,*back,*product_button;
@property(nonatomic,retain)UITextView *order_textview,*remarks_textview;
@property(nonatomic,retain)NSString *plan_id,*location_string,*clinicname_string,*summary_id;
@property(nonatomic,retain) UITextField *quantity,*samplechitno;

-(IBAction)togglecall;
-(IBAction)toggleassistant;
-(IBAction)GetDate;
-(IBAction)UpdateCallSummary;
-(void)PassValue:(NSDictionary *)dict;
-(IBAction)backbtn_clicked;\
-(IBAction)Get_Product;

@end
