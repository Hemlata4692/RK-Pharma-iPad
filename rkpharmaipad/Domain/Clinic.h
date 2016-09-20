//
//  Clinic.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clinic : NSObject
{
    NSString *clinic_id,*clinic_name,*phone_number,*pin_code,*location,*doctor_name,*offset,*dateto_string,*datefrom_string,*lastvisited,*specialization_id,*isSearch;
    //NSMutableArray *doctors,*Business_hours;
}
@property (nonatomic, retain) NSString *clinic_id,*clinic_name,*phone_number,*pin_code,*location,*doctor_name,*offset,*dateto_string,*datefrom_string,*lastvisited,*specialization_id,*isSearch;
@property ( nonatomic,retain) NSString *LocationId,*ProductId,*LastVisited;
@end
