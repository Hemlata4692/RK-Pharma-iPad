//
//  KIVViewController.h
//  RKPharma
//
//  Created by Shivendra on 09/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductManager.h"
#import "UserManager.h"

@interface KIVViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *ProductArray,*location_array;
    IBOutlet UITableView *KIV_table;
    NSMutableArray *KIV_array;
    IBOutlet UILabel *clinicname,*location,*product,*status,*error,*kivdate,*staff_name_label,*staff_username;
    IBOutlet UIButton *search_button,*reset_button,*dateto_button,*datefrom_button;
    IBOutlet UITextView *remarks;
    UIPickerView *area_picker,*Product_Picker;
    UIToolbar *area_picker_toolbar,*Product_Picker_toolbar;
    UIToolbar *toolbar,*toolbar1;
}

@property(nonatomic,retain)UITableView *KIV_table;
@property(nonatomic,retain)UIToolbar *area_picker_toolbar,*Product_Picker_toolbar;
@property(nonatomic,retain)UILabel *clinicname,*location,*product,*status,*error,*kivdate,*staff_name_label,*staff_username;
@property(nonatomic,retain)UIButton *search_button,*reset_button,*dateto_button,*datefrom_button;
@property(nonatomic,retain)UITextView *remarks;

-(IBAction)SelectProduct:(id)sender;
-(IBAction)SelectArea:(id)sender;
-(IBAction)SearchKIV;
-(IBAction)resetKIV:(id)sender;


@end
