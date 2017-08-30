//
//  EventCalendar.m
//  系统日历事件的增加与删除
//
//  Created by 彭盛凇 on 2017/8/14.
//  Copyright © 2017年 huangbaoche. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface EventCalendar ()

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation EventCalendar

static EventCalendar *calendar;

+ (instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    
    return calendar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)setEventCalendarTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate remark:(NSString *)remark authed:(BOOL)authed orderNo:(NSString *)orderNo operationSucceed:(OperationSucceed)operationSucceed{
    
    
    if (!authed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            operationSucceed(YES);
            
//            HBCAlertButton *button = [[HBCAlertButton alloc]initWithTitle:@"知道了" action:nil];
//            HBCAlertButton *confirm = [[HBCAlertButton alloc]initWithTitle:@"设置" action:^(HBCAlertButton *btn) {
//                
//                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
//                    
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }
//                
//            }];
//            HBCAlertView *alert = [[HBCAlertView alloc]initWithTitle:@"打开日历提醒功能，绝不错过一个订单！请在iPhone的“设置->隐私->日历”选项中，允许皇包车访问您的日历" message:nil cancelButton:confirm otherButtons:button,nil];
//            [alert show];
//            return;
            
        });
        return;
    }

    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
    event.title     = title;
    
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    event.startDate = startDate;
    event.endDate   = endDate;
    event.allDay = YES;
    event.notes = remark;

    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:startDate];
    
//    NSString *string = [NSString stringWithFormat:@"%@ 09:00:00", [lastDay stringValue]];
//
//    NSDate *lastDay_9 = [string defaultDate];
    
    
#warning addAlarm 为 添加提醒时间，系统默认使用本地推送提醒
    
//    [event addAlarm:[EKAlarm alarmWithAbsoluteDate:lastDay_9]];
    
//    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    NSError *err;
//    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    if (!err) {
        
        operationSucceed(YES);
        
        NSLog(@"添加成功！id：%@",event.eventIdentifier);
        
        [[NSUserDefaults standardUserDefaults] setObject:event.eventIdentifier forKey:orderNo];
        
    }else{
        
        operationSucceed(NO);
        
        NSLog(@"添加失败：%@",err);
    }
}

- (void)createEventCalendarTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate remark:(NSString *)remark orderNo:(NSString *)orderNo operationSucceed:(OperationSucceed)operationSucceed{
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    __weak typeof(self) weakSelf = self;
    
    /*
     EKAuthorizationStatusNotDetermined = 0,
     EKAuthorizationStatusRestricted,
     EKAuthorizationStatusDenied,
     EKAuthorizationStatusAuthorized,
     */
    
    if (status == EKAuthorizationStatusNotDetermined) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            
            [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:granted orderNo:orderNo operationSucceed:operationSucceed];
            
        }];
    }else if (status == EKAuthorizationStatusAuthorized) {
        
        [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:YES orderNo:orderNo operationSucceed:operationSucceed];
        
    }else {
        
        [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:NO orderNo:orderNo operationSucceed:operationSucceed];
    }

}

- (void)deleteEventWithOrderNo:(NSString *)orderNo operationSucceed:(OperationSucceed)operationSucceed {
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    __weak typeof(self) weakSelf = self;
    
    /*
     EKAuthorizationStatusNotDetermined = 0,
     EKAuthorizationStatusRestricted,
     EKAuthorizationStatusDenied,
     EKAuthorizationStatusAuthorized,
     */
    
    if (status == EKAuthorizationStatusNotDetermined) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            
            [weakSelf deleteEvent_1WithOrderNo:orderNo authed:granted operationSucceed:operationSucceed];
            
        }];
    }else if (status == EKAuthorizationStatusAuthorized) {
        
        [weakSelf deleteEvent_1WithOrderNo:orderNo authed:YES operationSucceed:operationSucceed];
    }else {
        
        [weakSelf deleteEvent_1WithOrderNo:orderNo authed:NO operationSucceed:operationSucceed];
    }
    
}

- (void)deleteEvent_1WithOrderNo:(NSString *)orderNo authed:(BOOL)authed operationSucceed:(OperationSucceed)operationSucceed {
    
    if (!authed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            operationSucceed(YES);
            
//            HBCAlertButton *button = [[HBCAlertButton alloc]initWithTitle:@"知道了" action:nil];
//            HBCAlertButton *confirm = [[HBCAlertButton alloc]initWithTitle:@"设置" action:^(HBCAlertButton *btn) {
//                
//                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
//                    
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }
//                
//            }];
//            HBCAlertView *alert = [[HBCAlertView alloc]initWithTitle:@"打开日历提醒功能，绝不错过一个订单！请在iPhone的“设置->隐私->日历”选项中，允许皇包车访问您的日历" message:nil cancelButton:confirm otherButtons:button,nil];
//            [alert show];
//            return;
//            
        });
        return;
    }
    
    NSString *eventIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:orderNo];
    
    EKEvent *event = [self.eventStore eventWithIdentifier:eventIdentifier];
    
    NSError *error;
    
    [self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
    
    if (!error) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:orderNo];
        
        operationSucceed(YES);
        
        NSLog(@"删除成功：id：%@",eventIdentifier);
    }else {
        
        operationSucceed(NO);
        
        NSLog(@"删除失败：%@",error);
    }

}

- (BOOL)isHasEventWithOrderNo:(NSString *)orderNo {
    
    if (NULLString(orderNo)) {
        return NO;
    }
    
    NSString *eventIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:orderNo];
    
    EKEvent *event = [self.eventStore eventWithIdentifier:eventIdentifier];
    
    if (event && isNotNullString(eventIdentifier)) {
        
        return YES;
    }else {
        return NO;
    }
    
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}


@end
