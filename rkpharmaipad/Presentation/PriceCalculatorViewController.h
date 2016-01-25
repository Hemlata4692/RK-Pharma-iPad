//
//  PriceCalculatorViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCalculatorViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    IBOutlet UIPickerView *product_picker;
    NSMutableArray *product_array;
    IBOutlet UITextField *main_quantity,*bonus_quantity,*unofficial_bonus;
    IBOutlet UIButton *calculate_button,*product_button,*next_button,*previous_button;
    IBOutlet UILabel *doctor_price_label,*result_label;
    UIToolbar *toolbar;
}
@property(nonatomic,retain)UIPickerView *product_picker;
@property(nonatomic,retain)UIButton *product_button,*calculate_button,*next_button,*previous_button;
@property(nonatomic,retain)UITextField *main_quantity,*bonus_quantity,*unofficial_bonus;
@property(nonatomic,retain)UILabel *doctor_price_label,*result_label;

-(IBAction)Get_product;

//Called calculate method
-(IBAction)calculate_btn_clicked;
-(IBAction)next_btn_clicked;
-(IBAction)previous_btn_clicked;

@end
