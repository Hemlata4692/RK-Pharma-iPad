//
//  ReturnSample.h
//  RKPharma
//
//  Created by Shiven on 8/28/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderManager.h"
#import "SampleRequestDomain.h"
#import "DataModel.h"
#import "DejalActivityView.h"
#import "SampleRequestListViewController.h"

@class SampleRequestListViewController;

SampleRequestListViewController *sampleView;



@interface ReturnSample : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

{
    
    UIToolbar *toolbar_product,*toolbar_date,*Product_Picker_toolbar;
    
    UIPickerView *Product_Picker;
    
    NSIndexPath *rowIndex ;
    
    UIDatePicker *DatePicker;
    
}
@property(nonatomic,retain)  UIToolbar *toolbar_product,*toolbar_date,*Product_Picker_toolbar;

- (IBAction)Submit:(id)sender;

- (IBAction)ChangeDate:(UIButton *)sender;

- (IBAction)Back:(id)sender;

@end