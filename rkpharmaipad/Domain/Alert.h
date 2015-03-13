//
//  Alert.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject
{
    NSString *location_string,*clinic_string,*remarks_string,*reminder_id,*current_datetime;
}
@property (nonatomic, retain) NSString *location_string,*clinic_string,*remarks_string,*reminder_id,*current_datetime;

@end
