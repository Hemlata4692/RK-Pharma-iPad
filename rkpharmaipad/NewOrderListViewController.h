//
//  NewOrderListViewController.h
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddOrderViewController;
AddOrderViewController *addordercontroller;
@interface NewOrderListViewController : UIViewController

<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITableView *order_table;
    IBOutlet UIPickerView *location_picker,*product_picker,*specialization_picker;
    IBOutlet UIDatePicker *datefrom_picker,*dateto_picker;
    UIToolbar *location_picker_toolbar,*product_picker_toolbar,*specialization_picker_toolbar,*datefrom_picker_toolbar,*dateto_picker_toolbar;
    NSMutableArray *order_array,*location_array,*product_array,*specialization_array;
    IBOutlet UILabel *clinic_name,*product_name,*order_quantity,*order_date,*invoice_no,*bonus,*unofficial_bonus,*status,*error_label,*remarks,*gtotal,*totalamount,*totalamountlabel,*gtotallabel,*sno;
    IBOutlet UIButton *datefrom_button,*dateto_button,*product_button,*location_button,*specialization_button,*close_Button,*addorder_button;
    UIButton *Edit_Button,*view_Button;
    IBOutlet UIActivityIndicatorView *indicator;
}
@property (nonatomic, retain) IBOutlet UIWebView *pdfView;
@property(nonatomic,retain)UITableView *order_table;
@property(nonatomic,retain)UIPickerView *location_picker,*product_picker,*specialization_picker;
@property(nonatomic,retain)UIDatePicker *datefrom_picker,*dateto_picker;
@property(nonatomic,retain)UILabel *clinic_name,*product_name,*order_quantity,*order_date,*invoice_no,*bonus,*unofficial_bonus,*status,*error_label,*remarks,*gtotal,*totalamount,*totalamountlabel,*gtotallabel,*sno;
@property(nonatomic,retain)UIButton *datefrom_button,*dateto_button,*product_button,*location_button,*specialization_button,*addorder_button;
@property(nonatomic,retain) UIToolbar *location_picker_toolbar,*product_picker_toolbar,*specialization_picker_toolbar,*datefrom_picker_toolbar,*dateto_picker_toolbar;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;

-(IBAction)SearchOrder;
-(IBAction)ResetOrder;
-(IBAction)GetDateFrom;
-(IBAction)GetDateTo;
-(IBAction)Get_Location;
-(IBAction)ChangeDateToLabel:(id)sender;
-(IBAction)GetSpecialization;
-(IBAction)Get_Product;
-(IBAction)add_order:(id)sender;
-(IBAction)closePDF:(id)sender;
@end
