/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "WebNotifications.h"

@implementation WebNotifications

- (void)addNotification:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    // w3c options:
	NSString *title = [options objectForKey:@"title"];
	NSString *body = [options objectForKey:@"body"];
	NSString *tag = [options objectForKey:@"tag"];
    //NSString *iconUrl = [options objectForKey:@"iconUrl"]; // Not supported
    
    // cordova option extensions:
    NSUnsignedInteger delay = [[options objectForKey:@"delay"] unsignedIntegerValue];
    NSString *soundUrl = [options objectForKey:@"soundUrl"];
    NSInteger badgeNumber = [[options objectForKey:@"badgeNumber"] intValue];

    //NSString *action = [options objectForKey:@"action"];
    //bool hasAction = ([[options objectForKey:@"hasAction"] intValue] == 1) ? YES : NO;
    //alertAction

	UILocalNotification *notif = [[UILocalNotification alloc] init];
	notif.alertBody = [NSString stringWithFormat:@"[%@] %@: %@", tag, title, body];
    notif.timeZone = [NSTimeZone defaultTimeZone];

    notif.soundName = soundName;
    notif.applicationIconBadgeNumber = badge;
	
	NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",body,@"body",tag,@"tag",nil];
    notif.userInfo = userDict;
	
    if (delay != 0) {
        notif.fireDate = [[NSDate date] addTimeInterval:delay];
        //notif.repeatInterval = [[repeatDict objectForKey: repeat] intValue];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    } else {
        [[UIApplication sharedApplication] presentLocalNotificationNow:notif];
    }
}

- (void)cancelNotification:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString *tag = [options objectForKey:@"tag"];
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        if ([[notification.userInfo objectForKey:@"tag"] isEqualToString:tag]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (void)cancelAllNotifications:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}



@end
