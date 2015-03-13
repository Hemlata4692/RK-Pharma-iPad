//
//  AnnouncementViewController.m
//  RKPharma
//
//  Created by Dimple Pandey on 08/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementManager.h"
#import "JSON.h"
#import "DashboardViewController.h"
#import "DejalActivityView.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController
@synthesize announcement_table,announcement_title,announcement_description,announcement_date,back;
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
    
    // To Set View Background Image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_new.png"]];
    
    // Initialize array
    announcement_array = [[NSMutableArray alloc]init];
    
    
    //To Hide Extra separators at the footer of tableview
    self.announcement_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    //Create business manager class object
    AnnouncementManager *announcement_business=[[AnnouncementManager alloc]init];
    NSString *response=[announcement_business GetAllAnnouncement];//call businessmanager method
    NSLog(@" Announcement List response is %@",response);
    
    if (response.length !=0) 
    {
        NSDictionary *var =  [response JSONValue];
        NSLog(@"dict result List%@",var);
        
        for(NSDictionary *dictvar in var)
        {
            [announcement_array addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictvar objectForKey:@"Title"],@"Title",[dictvar objectForKey:@"Announcement"],@"Announcement",[dictvar objectForKey:@"AnnounceDate"],@"AnnounceDate",[dictvar objectForKey:@"CreatedBy"],@"CreatedBy",nil]];
            
        }
        [announcement_table reloadData];
        
        NSLog(@" Count Announcement Array %d",announcement_array.count);
        
        
        
        if(announcement_array.count == 0)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,0);
        }
        else if(announcement_array.count == 1)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,102);
        }
        else if(announcement_array.count == 2)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,204);
        }
        else if(announcement_array.count == 3)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,306);
        }
        else if(announcement_array.count == 4)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,408);
        }
        else if(announcement_array.count == 5)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,510);
        }
        else if(announcement_array.count == 6)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,612);
        }
        else if(announcement_array.count >= 7)
        {
            self.announcement_table.frame = CGRectMake(10,45,821,714);
        }

    }
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
    // Return the number of rows in the section.
    return announcement_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"announcementlist_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
    {
        UIImage *background_first = [UIImage imageNamed:@"listingbg_top.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background_first];
        cellBackgroundView.image = background_first;
        cell.backgroundView = cellBackgroundView;
        
    }
    else
    {
        UIImage *background = [UIImage imageNamed:@"listingbg_new.png"];
        UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
        cellBackgroundView.image = background;
        cell.backgroundView = cellBackgroundView;
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[announcement_array objectAtIndex:indexPath.row];
    announcement_title=(UILabel *)[cell viewWithTag:1];
    announcement_title.text = [itemAtIndex objectForKey:@"Title"];
    announcement_title.textColor= [UIColor colorWithRed:(3/255.0) green:(120/255.0) blue:(184/255.0) alpha:1];
    
    announcement_description=(UILabel *)[cell viewWithTag:2];
    announcement_description.numberOfLines = 3;
    announcement_description.text = [itemAtIndex objectForKey:@"Announcement"];
    
    announcement_date=(UILabel *)[cell viewWithTag:3];
    //announcement_date.text = [itemAtIndex objectForKey:@"AnnounceDate"];
    
    if(![[itemAtIndex objectForKey:@"CreatedBy"]  isEqualToString:@""])
    {
        NSString *announcement_datenuser = [itemAtIndex objectForKey:@"AnnounceDate"];
    
        announcement_datenuser = [announcement_datenuser stringByAppendingString:@",  "];
        announcement_datenuser = [announcement_datenuser stringByAppendingString:[itemAtIndex objectForKey:@"CreatedBy"]];
        announcement_date.text = announcement_datenuser;
    }
    else
    {
        announcement_date.text = [itemAtIndex objectForKey:@"AnnounceDate"];
    }
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(IBAction)backbtn_clicked
{
    [self displayActivityView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        dashboardcontroller = [storyboard instantiateViewControllerWithIdentifier:@"dashboard_screen"];
        dashboardcontroller.view.tag=990;
        dashboardcontroller.view.frame=CGRectMake(0,0, 841, 723);
        
        [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 480.0f, 841.0f, 723.0f)]; //notice this is OFF screen!
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [dashboardcontroller.view setFrame:CGRectMake( 0.0f, 0.0f, 841.0f, 723.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        
        [self.view addSubview:dashboardcontroller.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"send_video" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Dashboard",@"heading", nil]];
        [self removeActivityView];
    });
}



@end
