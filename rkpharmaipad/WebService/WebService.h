//
//  Webservice.h
//  RKPharma
//
//  Created by Ranosys Technologies on 4/25/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebService : UIViewController
{
    NSData *responseData;
    NSString *responseString;
}
-(NSString*)doLogin:(id)login;
-(NSString*)GetAnnouncement;
-(NSString*)GetClinicList:Request;
-(NSString*)GetClinicNameList:Request;
-(NSString*)GetArea;
-(NSString*)GetOrderList:Request;
-(NSString*)GetReminder;
-(NSString*)AddReminder:Request;
-(NSString*)GetProductList;
-(NSString*)GetAllProductList:Request;
-(NSString*)GetClinicDetail:Request;
-(NSString*)GetAllAnnouncement;
-(NSString*)DeleteDailyPlan:Planid;
-(NSString*)AddClinics:Request;
-(NSString*)GetDailyPlanSummarylist:Request;
-(NSString*)GetCallCardlist:Request;
-(NSString*)GetDailyReport:Request;
-(NSString*)GetSamples:Planid;
-(NSString*)AddCallSummary:Summary;
-(NSString*)GetMeetingSummary:Summary;
-(NSString*)DeleteReminder:ReminderId;
-(NSString*)GetDailyPlanWeb:Request;
-(NSString*)GetSingaporeTime;
-(NSString*)GetSpecialization;
-(NSString*)SendUserLocation:Location;
-(NSString*)GetOrdersTotal:Request;
-(NSString*)GetMeetingSummaryDetails:Request;
-(NSString*)EditMeetingSummary:Summary;
-(NSString*)GetGeoCode:Pincode;
-(NSString*)GetProductsKIV:Request;
-(NSString*)GetSampleRequestList:Request;
-(NSString*)GetNewProductsLists:(id)Request;

- (NSString *)call_Webservice:(id)arguments;
-(NSString*)GetProductInfo:(id)Request;
-(NSString*)RepeatProductInfo:Request;
-(NSString*)RepeatDeliveryTerm:(id)Request;
-(NSString*)AddOrder:(id)Request;
-(NSString*)getOrderData:(id)Request;
-(NSString*)EditOrder:(id)Request;
-(NSString*)GetSampleReturnList:Request;
-(NSString*)GetSampleDetails:Request;

@end
