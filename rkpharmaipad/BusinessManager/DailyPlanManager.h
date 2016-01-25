//
//  DailyPlanManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyPlanManager : NSObject
{
    NSMutableData *dailyplan_responseData;
}
- (NSString*)GetDailyPlan:(id)plandate_object;
- (NSString*)DeleteDailyPlan:(id)plan_object;
- (NSString*)AddClinics:(id)clinic_object;
- (NSString*)GetDailyPlanSummarylist:(id)plan_object;
- (NSString*)GetCallCardlist:(id)callcard_object;
- (NSString*)GetDailyReport:(id)dailyreport_object;
- (NSString*)GetSamples:(id)planid_object;
- (NSString*)AddCallSummary:(id)summary_object;
- (NSString*)GetMeetingSummary:(id)summary_object;
- (NSString*)GetSingaporeTime;
- (NSString*)GetMeetingSummaryDetails:(id)summary_object;
- (NSString*)EditMeetingSummary:(id)summary_object;
@end
