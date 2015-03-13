//
//  LeftSidebarViewController.h
//  RKPharma
//
//  Created by Shivendra  singh on 29/04/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DashboardViewController,ClinicListViewController,OrderListViewController,AdminAlertViewController,ProductListViewController,PriceCalculatorViewController,DailyPlanSummaryListViewController,CallCardViewController,KIVViewController,SampleRequestListViewController;
ClinicListViewController *clinicslistcontroller;
DashboardViewController *dashboardcontroller;
OrderListViewController *orderlistcontroller;
AdminAlertViewController *adminalertcontroller;
ProductListViewController *productslistcontroller;
PriceCalculatorViewController *pricecalculatorcontroller;
DailyPlanSummaryListViewController *dailyplansummarylistcontroller;
CallCardViewController *callcardcontroller;
KIVViewController *KIVcontroller;
SampleRequestListViewController *SampleRequestController;
@interface LeftSidebarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel *sidebar_label,*topheading_label,*topusername_label;
    IBOutlet UIImageView *sidebar_image;
    NSMutableArray *sidebar_array;
    IBOutlet UITableView *sidebar_table;
    
}
-(void)ChangeLabelText:(NSNotification *)title;
@property(nonatomic,retain)UILabel *sidebar_label,*topheading_label,*topusername_label;
@property(nonatomic,retain)UIImageView *sidebar_image;
@property(nonatomic,retain)UITableView *sidebar_table;

@end
