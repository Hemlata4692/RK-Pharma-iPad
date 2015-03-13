//
//  AdminAlertViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminAlertViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *alert_table;
    IBOutlet UITextView *reminder;
     UIToolbar *location_picker_toolbar,*clinic_picker_toolbar;
    IBOutlet UIPickerView *location_picker,*clinic_picker;
    NSMutableArray *alert_array,*location_array,*clinic_array;
    IBOutlet UILabel *reminder_label,*clinic_label,*location_label,*date_label,*status_label,*admin_remarks,*error,*sno;
    IBOutlet UIButton *location_button,*clinic_button,*addreminder_button;
}
@property(nonatomic,retain)UITableView *alert_table;
@property(nonatomic,retain)UITextView *reminder;
@property(nonatomic,retain)UIToolbar *location_picker_toolbar,*clinic_picker_toolbar;
@property(nonatomic,retain)UIButton *location_button,*clinic_button,*addreminder_button;
@property(nonatomic,retain)UIPickerView *location_picker,*clinic_picker;
@property(nonatomic,retain)UILabel *reminder_label,*clinic_label,*location_label,*date_label,*status_label,*admin_remarks,*error,*sno;

-(IBAction)Get_Location;
-(IBAction)Get_Clinic;
-(IBAction)AddReminder;
@end
