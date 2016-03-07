//
//  YHCPickerView.m
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "YHCPickerView.h"

@implementation YHCPickerView
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{
    
    self = [super initWithFrame:frame];
    if (self) {
        frame1=frame;
        self.arrRecords = arrValues;
    }
    return self;
    
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
     NSString *strSelectedValue;
    
    if (searching ) 
    {
        if (copyListOfItems.count > 0) 
        {
            strSelectedValue = [copyListOfItems objectAtIndex:[pickerView selectedRowInComponent:0]];
            int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
            NSLog(@"Selecrted Value %@",strSelectedValue);
            NSLog(@"Selecrted Index %d",selectedIndex);
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
            {
                [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
            }
            
        }
        else
        {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
            {
                [self.delegate selectedRow:-1 withString:@"NOT FOUND"];
            }
        }
        
    }
    else
    {
        strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
        int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
        {
            [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
        }
    }
    
    [self removeFromSuperview];
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = pickerView.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, pickerView.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        
    }
}

-(void)hidePicker
{
    [self removeFromSuperview];
}
-(void)showPicker{
    
    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor clearColor];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, frame1.origin.y, 320.0, frame1.size.height - 44 - 31)];
    
    // Added By Shiven
    // To Show Location Picker View
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [pickerView addGestureRecognizer:gestureRecognizer];
    
    //[picketView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame1.origin.y-44, 320, 44)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithWhite:0.872 alpha:1.000];
    
    //    picketToolbar.barStyle = UIBarStyleBlackOpaque;
    //    [picketToolbar sizeToFit];
    
    txtSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, 240, 31)];
    txtSearch.tag = 1;
    txtSearch.barStyle = UIBarStyleBlackTranslucent;
    txtSearch.backgroundColor = [UIColor clearColor];
    txtSearch.delegate = self;
    txtSearch.userInteractionEnabled = TRUE;
    
    for (UIView *subview in txtSearch.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    } 
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClick)];
    [picketToolbar addSubview:txtSearch];
    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = NO;
	letUserSelectRow = NO;
    ////    if (pickerView) {
    ////        [pickerView removeFromSuperview];
    ////    }
    //    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    //    pickerView.showsSelectionIndicator = YES;
    //    pickerView.delegate = self;
    //    pickerView.dataSource = self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
        
		searching = YES;
		letUserSelectRow = YES;
        
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
        
	}
	
	[pickerView reloadAllComponents];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self btnDoneClick];
}

- (void) searchTableView {
	
	NSString *searchText = txtSearch.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
	
	for (NSString *sTemp in self.arrRecords)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0){
			[copyListOfItems addObject:sTemp];
        }
	}
    [pickerView reloadAllComponents];
	
	[searchArray release];
	searchArray = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)btnDoneClick
{
    
    NSString *strSelectedValue;
    if (searching ) 
    {
        if (copyListOfItems.count > 0) 
        {
            strSelectedValue = [copyListOfItems objectAtIndex:[pickerView selectedRowInComponent:0]];
            int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
            NSLog(@"Selecrted Value %@",strSelectedValue);
            NSLog(@"Selecrted Index %d",selectedIndex);
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
            {
                [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
            }
            
        }
        else
        {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
            {
                [self.delegate selectedRow:-1 withString:@"NOT FOUND"];
            }
        }
        
    }
    else
    {
        strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
        int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) 
        {
            [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
        }
    }
    
    [self removeFromSuperview];
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (searching) {
        return copyListOfItems.count;
    }else{
        return self.arrRecords.count;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    if (searching) {
//        return [copyListOfItems objectAtIndex:row];
//    }else{
//        return [self.arrRecords objectAtIndex:row];
//    }
//    
//}

- (UIView *)pickerView:(UIPickerView *)pickerView

            viewForRow:(NSInteger)row

          forComponent:(NSInteger)component

           reusingView:(UIView *)view 
{
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) 
    {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 260, 150);
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [pickerLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        
    }
    
    //picker view array is the datasource
    
    
    if (searching) {
        [pickerLabel setText:[copyListOfItems objectAtIndex:row]];
    }else{
        [pickerLabel setText:[self.arrRecords objectAtIndex:row]];
    }
    
    return pickerLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

@end
