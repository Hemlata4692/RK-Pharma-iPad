//
//  EditReturnSample.h
//  RKPharma
//
//  Created by Shiven on 9/17/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleRequestDomain.h"
#import "DataModel.h"
#import "DejalActivityView.h"
#import "SampleRequestListViewController.h"

@interface EditReturnSample : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIToolbar *toolbar_product,*toolbar_date;
    UIPickerView *Product_Picker;
    NSIndexPath *rowIndex ;
    UIDatePicker *DatePicker;
    NSMutableArray *returnsample_array;
}
- (IBAction)Submit:(id)sender;
//- (IBAction)ChangeDate:(UIButton *)sender;
- (IBAction)Back:(id)sender;
@end
