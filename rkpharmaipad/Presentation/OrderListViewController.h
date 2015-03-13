//
//  OrderListViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITableView *order_table;
    IBOutlet UIPickerView *location_picker,*product_picker,*specialization_picker;
    IBOutlet UIDatePicker *datefrom_picker,*dateto_picker;
    UIToolbar *location_picker_toolbar,*product_picker_toolbar,*specialization_picker_toolbar,*datefrom_picker_toolbar,*dateto_picker_toolbar;
    NSMutableArray *order_array,*location_array,*product_array,*specialization_array;
    IBOutlet UILabel *clinic_name,*product_name,*order_quantity,*order_date,*invoice_no,*bonus,*unofficial_bonus,*status,*error_label,*remarks,*gtotal,*totalamount,*totalamountlabel,*gtotallabel,*sno;
    IBOutlet UIButton *datefrom_button,*dateto_button,*product_button,*location_button,*specialization_button;
    IBOutlet UIActivityIndicatorView *indicator;
}
@property(nonatomic,retain)UITableView *order_table;
@property(nonatomic,retain)UIPickerView *location_picker,*product_picker,*specialization_picker;
@property(nonatomic,retain) UIToolbar *location_picker_toolbar,*product_picker_toolbar,*specialization_picker_toolbar,*datefrom_picker_toolbar,*dateto_picker_toolbar;
@property(nonatomic,retain)UIDatePicker *datefrom_picker,*dateto_picker;
@property(nonatomic,retain)UILabel *clinic_name,*product_name,*order_quantity,*order_date,*invoice_no,*bonus,*unofficial_bonus,*status,*error_label,*remarks,*gtotal,*totalamount,*totalamountlabel,*gtotallabel,*sno;
@property(nonatomic,retain)UIButton *datefrom_button,*dateto_button,*product_button,*location_button,*specialization_button;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;

-(IBAction)SearchOrder;
-(IBAction)ResetOrder;
-(IBAction)GetDateFrom;
-(IBAction)GetDateTo;
-(IBAction)Get_Location;
-(IBAction)ChangeDateToLabel:(id)sender;
-(IBAction)ChangeDateFromLabel:(id)sender;
-(IBAction)Get_Product;
-(IBAction)GetSpecialization;
@end
