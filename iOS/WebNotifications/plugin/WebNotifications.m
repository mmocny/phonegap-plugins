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

  /* w3c Spec: http://www.w3.org/TR/notifications/
   * DOMString title;
   * NotificationDirection titleDir;
   * DOMString body;
   * NotificationDirection bodyDir;
   * DOMString tag;
   * DOMString iconUrl;
   */

	NSString *title = [options objectForKey:@"title"];
	NSString *body = [options objectForKey:@"body"];
	NSString *tag = [options objectForKey:@"tag"];
	//NSString *iconUrl = [options objectForKey:@"iconUrl"];

	//NSString *action = [options objectForKey:@"action"];
	//NSInteger badge = [[options objectForKey:@"badge"] intValue];
	//bool hasAction = ([[options objectForKey:@"hasAction"] intValue] == 1) ? YES : NO;

	UILocalNotification *notif = [[UILocalNotification alloc] init];
	notif.fireDate = [[NSDate date] addTimeInterval:5];
	//notif.hasAction = hasAction;
	//notif.timeZone = [NSTimeZone defaultTimeZone];
  //notif.repeatInterval = [[repeatDict objectForKey: repeat] intValue];
	notif.alertBody = [NSString stringWithFormat:@"[ %@ ] %@", title, body];
	//notif.alertAction = action;
  //notif.soundName = sound;
  //notif.applicationIconBadgeNumber = badge;
	
	NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:tag,@"tag",nil];
  notif.userInfo = userDict;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:notif]; // presentLocalNotificationNow:
	//[notif release];
}

- (void)cancelNotification:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
  /*
	NSString *notificationId = [arguments objectAtIndex:0];
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for (UILocalNotification *notification in notifications) {
		NSString *notId = [notification.userInfo objectForKey:@"notificationId"];
		if ([notificationId isEqualToString:notId]) {
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}
	*/
}

- (void)cancelAllNotifications:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}



@end
