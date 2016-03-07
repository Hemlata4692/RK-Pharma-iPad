//
//  AddOrderViewController.h
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewOrderListViewController;
NewOrderListViewController *neworderlistcontroller;

@interface AddOrderViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *orderDate,*delivery_date,*select_area,*select_clinic,*order_type,*order_source,*tod,*select_specialization,*submit_button,*repeatDeliveryTerm;
    UIPickerView *area_picker,*clinic_picker,*specialization_Picker;
    UIDatePicker *orderDatepicker,*orderDatepicker1;
    IBOutlet UITextView *delivery_note,*comments;
    IBOutlet UITextField *preferred_time;
    
    __weak IBOutlet UITextView *remarks;
    //Add Product
    int page;
    UIToolbar *toolBar,*toolBar1,*clinic_picker_toolbar,*area_picker_toolbar;
    NSArray *countryNames;
    NSIndexPath *rowIndex;
    NSMutableArray *arr;
    NSMutableDictionary *d;
    NSString *orderId;
    //Add
}
@property (nonatomic, retain) id ordeObject;
@property (nonatomic, retain) NSString *orderId;
//Add Product
@property (nonatomic, retain) IBOutlet UIScrollView *external_scrool,*internal_scroll;
@property(nonatomic,strong)IBOutlet UITableView *table;
@property(nonatomic,strong)UIPickerView *productPicker;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong) UIToolbar *toolBar,*toolBar1,*clinic_picker_toolbar,*area_picker_toolbar;
//Add
//@property (nonatomic, retain) IBOutlet UITableView *productTableView;
@property (nonatomic, retain) NSMutableArray *areaArray,*clinicArray,*specializationArray,*productArray,*oldProductArray,*latestProductArray;
-(IBAction)Get_Specialization;
- (IBAction)AddButtonAction:(id)sender;
-(IBAction)button_select:(id)sender;
-(IBAction)submit:(id)sender;
- (IBAction)Back:(id)sender;
@end
