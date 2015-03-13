//
//  EditSample.h
//  RKPharma
//
//  Created by shiv vaishnav on 03/08/13.
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

@interface EditSample :  UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIToolbar *toolbar,*toolbar1,*Product_Picker_toolbar;
    UIPickerView *Product_Picker;
    NSIndexPath *rowIndex ;
    UIDatePicker *DatePicker;
    NSMutableArray *ProductArray;
    NSDictionary *passDict;
    NSMutableArray *MainArray;
    NSDictionary *MainDictionary;
}
@property(nonatomic,retain) NSMutableArray *ProductArray;
- (void)getData: (NSDictionary *)dict;
- (IBAction)Submit:(id)sender;
- (IBAction)ChangeDate:(UIButton *)sender;
- (IBAction)Back:(id)sender;
@end
