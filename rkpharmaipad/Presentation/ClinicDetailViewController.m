//
//  ClinicDetailViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "ClinicDetailViewController.h"
#import "ClinicManager.h"
#import "Clinic.h"
#import "JSON.h"
#import "RKPharmaAdoptingAnAnnotation.h"
#import "DejalActivityView.h"
#import "ClinicListViewController.h"
#import "CallCardViewController.h"

@interface ClinicDetailViewController ()

@end

@implementation ClinicDetailViewController
@synthesize clinic_id,address_string,phone_string,pincode_string,doctor_table,doctorname_string,specialization_label,docphone_string,docemail_string,clinichrsfrom_label,clinichrsto_label,lattitude,longitude,mapView,businesshour_table,spinner,primarydoctortag_label,primarydoctortag_image,purchaser_label,back,fax_label,workinghour_label,callcard;
NSString *Clinic_adress;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)displayActivityView;
{
    [DejalBezelActivityView activityViewForView:self.view];
}


- (void)removeActivityView;
{
    // Remove the activity view, with animation for the two styles that support it:
    [DejalBezelActivityView removeViewAnimated:YES];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [back setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    [callcard setTitleColor:[UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1]forState:UIControlStateNormal];
    //callcard.hidden = YES;
    mapView.hidden = YES;
    spinner.hidden = NO;
    [self.spinner startAnimating];
    
    businesshour_table.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"businesshoursbg.png"]];
    
    doctor_array = [[NSMutableArray alloc]init];
    businesstime_array = [[NSMutableArray alloc]init];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSLog(@" Check Clinic Id: %@",[defaults objectForKey:@"ClinicId"]);
    
    // To set the background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    //Create domain class object
    Clinic *clinic=[[Clinic alloc]init];
    
    //set Clinic Name value in domain class
    clinic.clinic_id = [defaults objectForKey:@"ClinicId"];
    
    //Create business manager class object
    ClinicManager *cm_business=[[ClinicManager alloc]init];
    NSString *response=[cm_business GetClinicDetail:clinic];//call businessmanager login method and handle response
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict Clinic Detail%@",var);
        
        // NSString *address = (NSString *)[var objectForKey:@"Address"];
        //NSLog(@" Address : %@",address);
        Clinic_adress = [var objectForKey:@"Address"];
        address_string.text = [var objectForKey:@"Address"];
        pincode_string.text = [var objectForKey:@"PinCode"];
        phone_string.text = [var objectForKey:@"PhoneNumber"];
        purchaser_label.text = [var objectForKey:@"Purchaser"];
        fax_label.text = [var objectForKey:@"FaxNumber"];
        workinghour_label.text = [var objectForKey:@"WorkingDays"];
        specialization_label.text = [var objectForKey:@"ClinicSpecialization"];
        
        //[address_string sizeToFit];
        
        for(NSDictionary *dictvar in [var objectForKey:@"Doctors"])
        {
            NSLog(@"ARAY: %@",[dictvar objectForKey:@"DocContact"]);
            [doctor_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"DocContact"],@"DocContact",[dictvar objectForKey:@"DocEmail"],@"DocEmail",[dictvar objectForKey:@"DocIsPrimary"],@"DocIsPrimary",[dictvar objectForKey:@"DocName"],@"DocName",nil]];
        }
        
        for(NSDictionary *dictbusinessvar in [var objectForKey:@"BusinessHours"])
        {
            NSLog(@"ARAY Business Hours: %@",[dictbusinessvar objectForKey:@"ClinicHrsFrom"]);
            [businesstime_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictbusinessvar objectForKey:@"ClinicHrsFrom"],@"ClinicHrsFrom",[dictbusinessvar objectForKey:@"ClinicHrsTo"],@"ClinicHrsTo",nil]];
        }
        
        NSLog(@" Count Array %d",doctor_array.count);
        NSLog(@" Count Business Array %d",businesstime_array.count);
        [doctor_table reloadData];
        [businesshour_table reloadData];
        
        if(doctor_array.count == 0)
        {
            self.doctor_table.frame = CGRectMake(10,239,583,0);
        }
        else if(doctor_array.count == 1)
        {
            self.doctor_table.frame = CGRectMake(10,239,583,80);
        }
        else if(doctor_array.count >= 2)
        {
            self.doctor_table.frame = CGRectMake(10,239,583,160);
        }
        
        if(doctor_array.count <= 1 && businesstime_array.count <=2)
        {
            self.businesshour_table.frame = CGRectMake(601,239,229,80);
        }
        
        
        
       
        
        
        NSString *WebserviceUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=singapore+%@&sensor=true",[var objectForKey:@"PinCode"]];
        NSLog(@" WEB URL :%@",WebserviceUrl);
        NSURL *url = [NSURL URLWithString:WebserviceUrl];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //NSLog(@" GeoCode API : %@",responseString);//return webservice response
        
        NSDictionary *cooordinates_dict =  [responseString JSONValue];
        NSLog(@"dict GeoAPI%@",[cooordinates_dict objectForKey:@"results"]);
        for(NSDictionary *getresults in [cooordinates_dict objectForKey:@"results"])
        {
            NSDictionary *geometrydic = [getresults objectForKey:@"geometry"];
            NSLog(@"dict Geometry%@",[geometrydic objectForKey:@"location"]);
            NSDictionary *locationdic = [geometrydic objectForKey:@"location"];
            NSLog(@"dict LAttitude%@",[locationdic objectForKey:@"lat"]);
            NSLog(@"dict Longitude%@",[locationdic objectForKey:@"lng"]);
            double lat = [[locationdic objectForKey:@"lat"] doubleValue];
            double lng = [[locationdic objectForKey:@"lng"] doubleValue];
            
            
            [self.spinner stopAnimating];
            spinner.hidden = YES;
            mapView.hidden = NO;
            MKCoordinateRegion region;
            
            
            region.center.latitude = lat;
            region.center.longitude = lng;
            
            MKCoordinateSpan span;
            NSLog(@" Latitude : %f",lat);
            NSLog(@" Latitude : %f",lng);
            //double radius = placemark.region.radius / 100; // convert to km
            
            //NSLog(@"Radius is %f", radius);
            span.latitudeDelta =  0.005;
            span.longitudeDelta= 0.005;
            region.span = span;
            
            [mapView setRegion:region animated:YES];
            
            RKPharmaAdoptingAnAnnotation *landmark = [[RKPharmaAdoptingAnAnnotation alloc]init];
            CLLocationCoordinate2D coord = {.latitude =  lat, .longitude =  lng};
            landmark.coord1=coord;
            [mapView addAnnotation:landmark];
            
        }
        
        
        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        [geocoder geocodeAddressString:[var objectForKey:@"PinCode"] completionHandler:^(NSArray *placemarks, NSError *error) 
//         {
//             [self.spinner stopAnimating];
//             spinner.hidden = YES;
//             mapView.hidden = NO;
//             
//             CLPlacemark *placemark = [placemarks lastObject];
//             MKCoordinateRegion region;
//             
//             region.center.latitude = placemark.region.center.latitude;
//             region.center.longitude = placemark.region.center.longitude;
//             
//             MKCoordinateSpan span;
//             NSLog(@" Latitude : %f",placemark.region.center.latitude);
//             NSLog(@" Latitude : %f",placemark.region.center.longitude);
//             double radius = placemark.region.radius / 100; // convert to km
//             
//             NSLog(@"Radius is %f", radius);
//             span.latitudeDelta =  0.005;
//             span.longitudeDelta= 0.005;
//             region.span = span;
//             
//             [mapView setRegion:region animated:YES];
//             
//             RKPharmaAdoptingAnAnnotation *landmark = [[RKPharmaAdoptingAnAnnotation alloc]init];
//             CLLocationCoordinate2D coord = {.latitude =  placemark.region.center.latitude, .longitude =  placemark.region.center.longitude};
//             landmark.coord1=coord;
//             [mapView addAnnotation:landmark];
//             
//             
//         }];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSLog(@" Check Clinic Id: %@",clinic_id);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==doctor_table)
    {
        return doctor_array.count;
    }
    else 
    {
        return businesstime_array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==doctor_table)
    {
        return 80;
    }
    else 
    {
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==doctor_table)
    {
        static NSString *CellIdentifier = @"doctorlist_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *itemAtIndex = (NSDictionary *)[doctor_array objectAtIndex:indexPath.row];
        
        doctorname_string=(UILabel *)[cell viewWithTag:1];
        doctorname_string.text = [itemAtIndex objectForKey:@"DocName"];
        
        docemail_string=(UILabel *)[cell viewWithTag:2];
        docemail_string.text = [itemAtIndex objectForKey:@"DocEmail"];
        
        docphone_string=(UILabel *)[cell viewWithTag:4];
        docphone_string.text = [itemAtIndex objectForKey:@"DocContact"];
        
        primarydoctortag_label=(UILabel *)[cell viewWithTag:5];
        primarydoctortag_label.hidden = YES;
        
        if([[itemAtIndex objectForKey:@"DocIsPrimary"] isEqualToString:@"False"])
        {
            primarydoctortag_label=(UILabel *)[cell viewWithTag:5];
            primarydoctortag_label.hidden = YES;
            
            primarydoctortag_image=(UIImageView *)[cell viewWithTag:6];
            primarydoctortag_image.hidden = YES;
        }
        else 
        {
            primarydoctortag_label=(UILabel *)[cell viewWithTag:5];
            primarydoctortag_label.hidden = NO;
            
            primarydoctortag_image=(UIImageView *)[cell viewWithTag:6];
            primarydoctortag_image.hidden = NO;
        }
        
        UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
        
        return cell;
    }
    else 
    {
        static NSString *CellIdentifier = @"businesshour_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *itemAtIndex = (NSDictionary *)[businesstime_array objectAtIndex:indexPath.row];
        
        clinichrsfrom_label=(UILabel *)[cell viewWithTag:1];
        clinichrsfrom_label.text = [itemAtIndex objectForKey:@"ClinicHrsFrom"];
        
        clinichrsto_label=(UILabel *)[cell viewWithTag:2];
        clinichrsto_label.text = [itemAtIndex objectForKey:@"ClinicHrsTo"];
        
        return cell;
    }
    
    
}

- (IBAction)showcallcard
{
    NSLog(@" Call Card Clicked");
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        callcardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"callcard_screen"];
        callcardcontroller.view.tag=992;
        callcardcontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [callcardcontroller PassValue:[NSDictionary dictionaryWithObjectsAndKeys:[defaults objectForKey:@"ClinicId"],@"clinicid",[defaults objectForKey:@"ClinicName"],@"clinic_name",Clinic_adress,@"clinic_address",nil]];
        [callcardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [callcardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        [self.view addSubview:callcardcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Call Card",@"heading", nil]];
        [self removeActivityView];
    });
}

-(IBAction)backbtndetail_clicked
{
    //[self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    NSLog(@" BAck Button Clicked");
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
//        [clinicdetailviewcontroller.view removeFromSuperview];
//        [cliniclistcontroller.view removeFromSuperview];
        //[self.view removeFromSuperview];
        //[cliniclistcontroller.view removeFromSuperview];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        cliniclistcontroller = [storyboard instantiateViewControllerWithIdentifier:@"clinics_screen"];
        cliniclistcontroller.view.tag=990;
        cliniclistcontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        [cliniclistcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [cliniclistcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        
        [self.view addSubview:cliniclistcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Clinics",@"heading", nil]];
        [self removeActivityView];
    });
}


@end
