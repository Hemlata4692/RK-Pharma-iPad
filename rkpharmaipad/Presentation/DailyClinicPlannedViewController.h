//
//  DailyClinicPlannedViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 29/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallSummaryViewController,DailyPlanListViewController;
CallSummaryViewController *callsummarycontroller;
DailyPlanListViewController *dailyplanlistcontroller;
@interface DailyClinicPlannedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *planned_table;
    NSMutableArray *planned_array;
    IBOutlet UILabel *date,*clinicname,*locationname,*error_label;
    IBOutlet UIButton *fillsummary,*back;
    
}

@property(nonatomic,retain)UITableView *planned_table;
@property(nonatomic,retain)UILabel *date,*clinicname,*locationname,*error_label;
@property(nonatomic,retain)UIButton *fillsummary,*back;
-(IBAction)backbtn_clicked;

@end
