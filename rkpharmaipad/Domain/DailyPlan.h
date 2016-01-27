//
//  DailyPlan.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyPlan : NSObject
{
    IBOutlet NSString *plan_id,*clinic_id,*plan_date,*clinics_planned,*clinics_visited,*issue_quantity,*orderinfo,*remarks,*postcalldate,*samplechitno,*calltype,*assistant_selected,*IsVisited,*summaryId,*StartDate,*EndDate,*kiv_products,*unplanned,*kiv_clinics,*KIVclinic_id,*month,*year,*WebSummary,*divisionid;
}
@property (nonatomic, retain) NSString *plan_id,*clinic_id,*plan_date,*clinics_planned,*clinics_visited,*issue_quantity,*orderinfo,*remarks,*postcalldate,*samplechitno,*calltype,*assistant_selected,*IsVisited,*summaryId,*StartDate,*EndDate,*kiv_products,*unplanned,*kiv_clinics,*KIVclinic_id,*month,*year,*WebSummary,*divisionid;
@end
