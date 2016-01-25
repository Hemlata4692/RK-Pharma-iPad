//
//  SampleRequestListViewController.h
//  RKPharma
//
//  Created by Shivendra on 25/07/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSample.h"
#import "RKPharmaAppDelegate.h"

@class AddSample,EditSample,ReturnSample,ReturnSampleList;
AddSample *addsample;
EditSample *editSample;
ReturnSample *returnsample;
ReturnSampleList *returnsamplelist;

@interface SampleRequestListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITableView *sample_table;
    IBOutlet UIPickerView *product_picker;
    IBOutlet UIDatePicker *datefrom_picker,*dateto_picker;
    NSMutableArray *sample_array,*product_array;
    IBOutlet UILabel *error_label,*requested_date,*issued_quantity,*product_name,*remarks,*sample_status,*sno;
    
    IBOutlet UIButton *datefrom_button,*dateto_button,*product_button,*status_button,*requestsample_button,*returnsample_button;
    IBOutlet UIActivityIndicatorView *indicator;
    UIToolbar *toolbar,*toolbar1;
}
@property(nonatomic,retain)UITableView *sample_table;
@property(nonatomic,retain)UIPickerView *product_picker;
@property(nonatomic,retain)UIDatePicker *datefrom_picker,*dateto_picker;

@property(nonatomic,retain)UIButton *datefrom_button,*dateto_button,*product_button,*status_button,*requestsample_button,*returnsample_button;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;
@property(nonatomic,retain)UILabel *error_label,*requested_date,*issued_quantity,*product_name,*remarks,*sample_status,*sno;

-(IBAction)SearchSampleRequest;
-(IBAction)ResetSampleRequest;
-(IBAction)GetDateFrom;
-(IBAction)GetDateTo;
-(IBAction)ChangeDateToLabel:(id)sender;
-(IBAction)ChangeDateFromLabel:(id)sender;
-(IBAction)Get_Product;
- (IBAction)AddSample:(id)sender;
- (IBAction)ReturnSample:(id)sender;
- (IBAction)ReturnSampleList:(id)sender;
@end
