/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComSpriteBaidupushModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "TiApp.h"

@implementation ComSpriteBaidupushModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"8f211807-c5b1-4b75-b080-6a867c669da1";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.sprite.baidupush";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    NSDictionary *launchOptions = [[TiApp app] launchOptions];
   
    [[TiApp app] setRemoteNotificationDelegate:self];
    
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    //*
    UIApplication * app = [UIApplication sharedApplication];
    [app registerForRemoteNotificationTypes:
          UIRemoteNotificationTypeAlert
         | UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound];
    //*/
    NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Push Notification Delegates

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    NSMutableDictionary * event = [[NSMutableDictionary alloc] init];
    NSString* dt = [deviceToken description];
    [event setValue:dt forKey:@"device"];
    [self fireEvent:@"registered" withObject:event];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification :%@", userInfo);
    [BPush handleNotification:userInfo];
    [self fireEvent:@"notify" withObject:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString * message = [TiUtils messageFromError:error];
    NSMutableDictionary * event = [TiUtils dictionaryWithCode:[error code] message:message];
    [self fireEvent:@"registerFail" withObject:message];
}


- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSMutableDictionary alloc] initWithDictionary:data];
    int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
    [res setValue:(returnCode==0 ? @"ok" : @"fail") forKey:@"err"];
    [self fireEvent:method withObject:res];
}


#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)start:(id)params
{
 
    return @"ok";
}


-(id)bindChannel:(id)params
{
    ENSURE_UI_THREAD(bindChannel, params);
    NSLog(@"bindChannel");
    //[BPush setDelegate:self];
    [BPush bindChannel];
    return @"ok";
}

-(id)unbindChannel:(id)params
{
    ENSURE_UI_THREAD(unbindChannel, params);
    NSLog(@"unbindChannel");
    [BPush unbindChannel];
    return @"ok";
}

-(id)getInfo:(id)params
{
    NSMutableDictionary *rs = [[NSMutableDictionary alloc] init];
    [rs setValue:[BPush getChannelId] forKey:@"channel_id"];
    [rs setValue:[BPush getUserId] forKey:@"user_id"];
    [rs setValue:[BPush getAppId] forKey:@"app_id"];
    NSLog(@"getInfo: %@", rs);
    return rs;
}

@end
