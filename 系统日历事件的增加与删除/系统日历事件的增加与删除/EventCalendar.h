//
//  EventCalendar.h
//  系统日历事件的增加与删除
//
//  Created by 彭盛凇 on 2017/8/14.
//  Copyright © 2017年 huangbaoche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationSucceed)(BOOL isSucceed);

@interface EventCalendar : NSObject

+ (instancetype)sharedEventCalendar;

- (void)createEventCalendarTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate remark:(NSString *)remark orderNo:(NSString *)orderNo operationSucceed:(OperationSucceed)operationSucceed;

- (void)deleteEventWithOrderNo:(NSString *)orderNo operationSucceed:(OperationSucceed)operationSucceed;

- (BOOL)isHasEventWithOrderNo:(NSString *)orderNo;

@end
