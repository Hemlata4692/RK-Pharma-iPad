//
//  AlertManager.h
//  RKPharma
//
//  Created by Dimple Pandey on 24/04/13.
//  Copyright (c) 2013 Dimple Pandey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject
{
    NSMutableData *responseData;
}
- (NSString*)GetReminderList;
- (NSString*)AddReminder:(id)reminder_object;
- (NSString*)DeleteReminder:(id)reminderid_object;
@end
