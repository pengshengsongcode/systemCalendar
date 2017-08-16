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

- (void)setEventCalendarTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate remark:(NSString *)remark authed:(BOOL)authed orderNo:(NSString *)orderNo{
    
    
    if (!authed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        });
        return;
    }

    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
    event.title     = title;
    
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    event.startDate = startDate;
    event.endDate   = endDate;
    event.allDay = NO;
    event.notes = remark;

//    addAlarm
    
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    if (!err) {
        
        NSLog(@"添加成功！id：%@",event.eventIdentifier);
        
        [[NSUserDefaults standardUserDefaults] setObject:event.eventIdentifier forKey:@"eventIdentifier"];
        
    }else{
        NSLog(@"添加失败：%@",err);
    }
}

- (void)createEventCalendarTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate remark:(NSString *)remark orderNo:(NSString *)orderNo{
    
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
            
            [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:granted orderNo:orderNo];
            
        }];
    }else if (status == EKAuthorizationStatusAuthorized) {
        
        [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:YES orderNo:orderNo];
        
    }else {
        
        [weakSelf setEventCalendarTitle:title startDate:startDate endDate:endDate remark:remark authed:NO orderNo:orderNo];
    }

}

- (void)deleteEventWithEventIdentifier:(NSString *)eventIdentifier {
    
    EKEvent *event = [self.eventStore eventWithIdentifier:eventIdentifier];
    
    NSError *error;
    
    [self.eventStore removeEvent:event span:EKSpanFutureEvents commit:YES error:&error];
    
    if (!error) {
        NSLog(@"删除成功：id：%@",eventIdentifier);
    }else {
        NSLog(@"添加失败：%@",error);
    }
    
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}


@end
