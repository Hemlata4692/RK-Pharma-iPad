//
//  ClinicDetailViewController.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ClinicListViewController,CallCardViewController;
ClinicListViewController *cliniclistcontroller;
CallCardViewController * callcardcontroller;

@interface ClinicDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    IBOutlet NSString *clinic_id,*longitude,*lattitude;
    IBOutlet UILabel *pincode_string,*phone_string,*doctorname_string,*specialization_label,*docphone_string,*docemail_string,*clinichrsfrom_label,*clinichrsto_label,*primarydoctortag_label,*purchaser_label,*fax_label,*workinghour_label;
    NSMutableArray *doctor_array,*businesstime_array;
    IBOutlet UITableView *doctor_table,*businesshour_table;
    IBOutlet UITextView *address_string;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIImageView *primarydoctortag_image;
    IBOutlet UIButton *back,*callcard;
    
    NSData *responseData;
    NSString *responseString;
}
@property(nonatomic,retain)UIImageView *primarydoctortag_image;
@property(nonatomic,retain)UIButton *back,*callcard;
@property(nonatomic,retain)UIActivityIndicatorView *spinner;
@property(nonatomic,retain)MKMapView *mapView;
@property(nonatomic,retain)NSString *clinic_id,*longitude,*lattitude;
@property(nonatomic,retain)UITableView *doctor_table,*businesshour_table;
@property(nonatomic,retain)UILabel *pincode_string,*phone_string,*doctorname_string,*specialization_label,*docphone_string,*docemail_string,*clinichrsfrom_label,*clinichrsto_label,*primarydoctortag_label,*purchaser_label,*fax_label,*workinghour_label;
@property(nonatomic,retain)UITextView *address_string;
-(IBAction)backbtndetail_clicked;
-(IBAction)showcallcard;
@end
