//
//  DailyPlanReportViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallSummaryViewController,DailyPlanListViewController,EditCallSummaryViewController;
CallSummaryViewController *callsummarycontroller;
DailyPlanListViewController *dailyplanlistcontroller;
EditCallSummaryViewController *editcallsummarycontroller;
@interface DailyPlanReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *dailyreport_table;
    NSMutableData *responseData;
    NSMutableArray *dailyreport_array,*products_array;
    IBOutlet UILabel *clinicname_label,*location_label,*order,*remarks,*plan_date,*error,*clinicassistant;
    IBOutlet NSString *selected_date;
    IBOutlet UITextView *products;
    IBOutlet UIButton *fillsummary_button,*back;
    
}
@property(nonatomic,retain)UITableView *dailyreport_table;
@property(nonatomic,retain)UILabel *clinicname_label,*location_label,*order,*remarks,*plan_date,*error,*clinicassistant;
@property(nonatomic,retain)NSString *selected_date;
@property(nonatomic,retain)UITextView *products;
@property(nonatomic,retain)UIButton *fillsummary_button,*back;

-(IBAction)backbtn_clicked;

@end
