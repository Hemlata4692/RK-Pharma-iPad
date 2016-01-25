//
//  DailyPlanSummaryListViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DailyPlanReportViewController,CreatePlanViewController,DailyClinicPlannedViewController;
DailyPlanReportViewController *dailyplanreportcontroller;
CreatePlanViewController *createplancontroller;
DailyClinicPlannedViewController *clinicsplannedcontroller;
@interface DailyPlanSummaryListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *plan_table;
    NSMutableData *responseData;
    NSMutableArray *plan_array;
    IBOutlet UILabel *sno,*date,*no_of_clinics_planned,*no_of_clinics_visited,*error_label,*createplan_label,*dateshow_label,*error;
    IBOutlet UIButton *datefrom_button,*dateshow_button,*clinics_planned,*clinics_visited,*dateto_button,*createplan_button;
    IBOutlet UIDatePicker *datefrom_picker,*dateto_picker;
    UIToolbar *datefrom_picker_toolbar,*dateto_picker_toolbar;
    IBOutlet UITextView *manager_remarks,*areas;
    
}
@property(nonatomic,retain)UITextView *manager_remarks,*areas;
@property(nonatomic,retain)UITableView *plan_table;
@property(nonatomic,retain) UIToolbar *datefrom_picker_toolbar,*dateto_picker_toolbar;
@property(nonatomic,retain)UILabel *sno,*date,*no_of_clinics_planned,*no_of_clinics_visited,*error_label,*createplan_label,*dateshow_label,*error;
@property(nonatomic,retain)UIButton *datefrom_button,*dateshow_button,*dateto_button,*createplan_button;
@property(nonatomic,retain)UIDatePicker *datefrom_picker,*dateto_picker;

-(IBAction)GetDateFrom;
-(IBAction)GetDateTo;
-(IBAction)SearchPlan;
-(IBAction)ResetPlan;
-(IBAction)ChangeDateFromLabel:(id)sender;
-(IBAction)ChangeDateToLabel:(id)sender;
-(IBAction)createplan_btn_clicked;

@end
