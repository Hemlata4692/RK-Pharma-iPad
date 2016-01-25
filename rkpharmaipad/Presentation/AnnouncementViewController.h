//
//  AnnouncementViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 08/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardViewController;
DashboardViewController *dashboardcontroller;

@interface AnnouncementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *announcement_table;
    NSMutableData *responseData;
    NSMutableArray *announcement_array;
    IBOutlet UILabel *announcement_title,*announcement_description,*announcement_date;
    IBOutlet UIButton *back;
}
@property(nonatomic,retain)UITableView *announcement_table;
@property(nonatomic,retain)UILabel *announcement_title,*announcement_description,*announcement_date;
@property(nonatomic,retain)UIButton *back;

-(IBAction)backbtn_clicked;

@end
