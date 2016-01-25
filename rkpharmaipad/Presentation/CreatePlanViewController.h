//
//  CreatePlanViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
@class DailyPlanSummaryListViewController,DailyPlanListViewController;
DailyPlanListViewController *dailyplanlistcontroller;
DailyPlanSummaryListViewController *dailyplansummarylist;

@interface CreatePlanViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,ALPickerViewDelegate>
{
    IBOutlet UILabel *date_label;
    IBOutlet UIButton *submit_button,*clinic_button,*location_button,*date_button,*back;
    IBOutlet UIPickerView *location_picker;
    NSMutableArray *location_array,*clinic_array;
    NSArray *lastVisited_array;
    ALPickerView *clinic_picker;
    IBOutlet UIDatePicker *selectdate_picker;
    UIToolbar *location_picker_toolbar,*clinic_picker_toolbar,*selectdate_picker_toolbar;
    NSArray *entries;
	NSMutableDictionary *selectionStates;
}
@property(nonatomic,retain)UIDatePicker *selectdate_picker;
@property(nonatomic,retain)UILabel *date_label;
@property(nonatomic,retain) UIToolbar *location_picker_toolbar,*clinic_picker_toolbar,*selectdate_picker_toolbar,*lastVisited_picker_toolbar;
@property(nonatomic,retain)UIButton *submit_button,*clinic_button,*location_button,*date_button,*back;
@property(nonatomic,retain)UIPickerView *location_picker,*lastVisited_picker;

-(IBAction)Get_Location;
-(IBAction)Submit:(id)sender;
-(IBAction)GetDate;
-(IBAction)backbtn_clicked;

//lastVisited IBAction and outlet
- (IBAction)Get_lastVisited:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lastVisited_button;

@end
