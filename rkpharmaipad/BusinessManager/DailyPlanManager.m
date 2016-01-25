//
//  DailyPlanManager.m
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import "DailyPlanManager.h"
#import "WebService.h"
#import "JSON.h"

@implementation DailyPlanManager

- (NSString*)GetDailyPlan:(id)plandate_object
{
    //Call webservice method of login
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *dailyplan_string=[dailyplan_web GetDailyPlanWeb:plandate_object];
    return dailyplan_string;//get and return webservice response 
}

- (NSString*)DeleteDailyPlan:(id)plan_object
{
    //Call webservice method of login
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *dailyplan_string=[dailyplan_web DeleteDailyPlan:plan_object];
    return dailyplan_string;//get and return webservice response 
}

- (NSString*)AddClinics:(id)clinic_object
{
    //Call webservice method of login
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *dailyplan_string=[dailyplan_web AddClinics:clinic_object];
    return dailyplan_string;//get and return webservice response
}

- (NSString*)GetDailyPlanSummarylist:(id)plan_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetDailyPlanSummarylist:plan_object];
    return string;//get and return webservice response
}

- (NSString*)GetCallCardlist:(id)callcard_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetCallCardlist:callcard_object];
    return string;//get and return webservice response
}

- (NSString*)GetDailyReport:(id)dailyreport_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetDailyReport:dailyreport_object];
    return string;//get and return webservice response
}

- (NSString*)GetSamples:(id)planid_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetSamples:planid_object];
    return string;//get and return webservice response
}

- (NSString*)AddCallSummary:(id)summary_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web AddCallSummary:summary_object];
    return string;//get and return webservice response
}

- (NSString*)GetMeetingSummary:(id)summary_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetMeetingSummary:summary_object];
    return string;//get and return webservice response
}

- (NSString*)GetSingaporeTime
{
    //Call webservice method of login
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *dailyplan_string=[dailyplan_web GetSingaporeTime];
    return dailyplan_string;//get and return webservice response 
}

- (NSString*)GetMeetingSummaryDetails:(id)summary_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web GetMeetingSummaryDetails:summary_object];
    return string;//get and return webservice response
}

- (NSString*)EditMeetingSummary:(id)summary_object
{
    //Call webservice method of Clinic
    WebService *dailyplan_web=[[WebService alloc]init];
    NSString *string=[dailyplan_web EditMeetingSummary:summary_object];
    return string;//get and return webservice response
}

@end
