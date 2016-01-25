//
//  DashboardViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AnnouncementViewController,AddClinicViewController,CallSummaryViewController,CallCardViewController;
AnnouncementViewController *announcementlistcontroller;
AddClinicViewController *addcliniccontroller;
CallSummaryViewController *callsummarycontroller;
CallCardViewController *callcardcontroller;



@interface DashboardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    
    IBOutlet UILabel *currentdate_label,*currentweek_label,*currentyear_label,*currentmonth_label,*announcementdate_label,*announcementtitle_label,*clinicname_label,*location_label,*phone_label,*doctor_label,*dashboardusername_label,*clinichrsfrom1_label,*clinichrsfrom2_label,*clinichrsto1_label,*clinichrsto2_label,*sno;
    NSMutableData *responseData_dailyplan,*responseData_announcement;
    IBOutlet UITextView *announcement_textview;
    NSMutableArray *dailyplan_array,*businesshours_array;
    IBOutlet UITableView *Todaysplan_table;
    IBOutlet UIButton *announcement_button,*delete_button,*fillsummary_button,*addclinic_button,*clinicname_button;
    

}
@property (nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain)UILabel *currentdate_label,*currentweek_label,*currentyear_label,*currentmonth_label,*announcementdate_label,*announcementtitle_label,*clinicname_label,*location_label,*phone_label,*doctor_label,*dashboardusername_label,*clinichrsfrom1_label,*clinichrsfrom2_label,*clinichrsto1_label,*clinichrsto2_label,*sno,*purchaserName,*clinicAddress,*planDate,*dayOff;
@property(nonatomic,retain)UITextView *announcement_textview;
@property(nonatomic,retain)UITableView *Todaysplan_table;
@property(nonatomic,retain)UIButton *announcement_button,*delete_button,*fillsummary_button,*addclinic_button,*clinicname_button;


-(IBAction)announcement_btn_clicked;
-(IBAction)addclinic_btn_clicked;
-(IBAction)call_summary:(id)sender;





@end
