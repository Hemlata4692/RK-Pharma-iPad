//
//  ReturnSampleList.h
//  RKPharma
//
//  Created by Shiven on 9/3/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewReturnSample,EditReturnSample;
ViewReturnSample *viewreturnsample;
EditReturnSample *editreturnsample;

@interface ReturnSampleList : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *returnsample_table;
    IBOutlet UIDatePicker *datefrom_picker,*dateto_picker;
    NSMutableArray *returnsample_array;
    IBOutlet UILabel *error_label,*return_qty,*return_date,*batch_no,*exp_date,*issued_date,*product_name,*returnsample_status,*sno;
    
    IBOutlet UIButton *datefrom_button,*dateto_button,*status_button;
    IBOutlet UIActivityIndicatorView *indicator;
    UIToolbar *toolbar,*toolbar1;
}
@property(nonatomic,retain)UITableView *returnsample_table;
@property(nonatomic,retain)UIDatePicker *datefrom_picker,*dateto_picker;

@property(nonatomic,retain)UIButton *datefrom_button,*dateto_button,*status_button;
@property(nonatomic,retain)UIActivityIndicatorView *indicator;
@property(nonatomic,retain)UILabel *error_label,*return_qty,*return_date,*batch_no,*exp_date,*issued_date,*product_name,*returnsample_status,*sno;

-(IBAction)SearchSampleRequest;
-(IBAction)ResetSampleRequest;
-(IBAction)GetDateFrom;
-(IBAction)GetDateTo;
-(IBAction)ChangeDateToLabel:(id)sender;
-(IBAction)ChangeDateFromLabel:(id)sender;
- (IBAction)Back:(id)sender;

@end
