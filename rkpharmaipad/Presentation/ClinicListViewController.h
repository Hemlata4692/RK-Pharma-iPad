//
//  ClinicListViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCPickerView.h"
#import <EventKit/EventKit.h>
@class ClinicDetailViewController,ClinicListViewController;
ClinicDetailViewController *clinicdetailviewcontroller;
ClinicListViewController *cliniclistcontroller;
@interface ClinicListViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,YHCPickerViewDelegate>
{
    IBOutlet UITableView *clinic_table;
    IBOutlet UIPickerView *location_picker,*lastvisited_picker,*specialization_picker;
    UIToolbar *location_picker_toolbar,*lastvisited_picker_toolbar,*specialization_picker_toolbar;
    IBOutlet UILabel *clinic_name,*doctor_name,*phone_number,*location,*pin_code,*error_label,*clinichrsfrom1_label,*clinichrsfrom2_label,*clinichrsto1_label,*clinichrsto2_label,*last_visit,*sno,*sno_label;
    NSMutableData *responseData;
    NSMutableArray *clinic_array,*location_array,*businesshours_array,*lastvisited_array,*specialization_array;
    IBOutlet UITextField *search_clinic_field,*search_doctor_field,*search_phone_field,*search_pin_field,*search_area;
    IBOutlet UIButton *location_button,*lastvisited_button,*addtotodaysplan,*specialization_button,*plandate,*toTime,*fromTime;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableArray * clinicsArray;
    UIToolbar *toolbar,*toTimeToolbar,*fromTimeToolbar;
    UIDatePicker *DatePicker,*fromTimePicker,*toTimePicker;
    BOOL checksearchbar;
}
@property(nonatomic,retain)UITableView *clinic_table;
@property(nonatomic,retain)UITextField *search_clinic_field,*search_doctor_field,*search_phone_field,*search_pin_field,*search_area;
@property(nonatomic,retain)UILabel *clinic_name,*doctor_name,*phone_number,*location,*pin_code,*error_label,*clinichrsfrom1_label,*clinichrsfrom2_label,*clinichrsto1_label,*clinichrsto2_label,*last_visit,*sno,*sno_label;
@property(nonatomic,retain)UIPickerView *location_picker,*lastvisited_picker,*specialization_picker;
@property(nonatomic,retain)UIToolbar *location_picker_toolbar,*lastvisited_picker_toolbar,*specialization_picker_toolbar;
@property(nonatomic,retain)UIButton *location_button,*lastvisited_button,*addtotodaysplan,*specialization_button,*plandate;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;


-(IBAction)Get_Location;
-(IBAction)Get_specialization;
-(IBAction)Get_LastVisited;
-(IBAction)SearchClinic;
-(IBAction)ResetClinic;
@end
