//
//  ViewController.m
//  系统日历事件的增加与删除
//
//  Created by 彭盛凇 on 2017/8/14.
//  Copyright © 2017年 huangbaoche. All rights reserved.
//

#import "ViewController.h"
#import "EventCalendar.h"
#import <EventKit/EventKit.h>

@interface ViewController ()

@property (nonatomic, strong) EKEventStore *store;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)add:(id)sender {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 1;
    [[EventCalendar sharedEventCalendar] createEventCalendarTitle:@"彭宝宝" startDate:[NSDate date] endDate:[calendar dateByAddingComponents:components toDate:[NSDate date] options:0] remark:@"啦啦啦啦" orderNo:@"123"];
    
//    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
//    
//    
//    /*
//     EKAuthorizationStatusNotDetermined = 0,
//     EKAuthorizationStatusRestricted,
//     EKAuthorizationStatusDenied,
//     EKAuthorizationStatusAuthorized,
//     */
//    
//    if (status == EKAuthorizationStatusNotDetermined) {
//        [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
//            
//            [self doSaveData:granted];
//        }];
//    }else if (status == EKAuthorizationStatusAuthorized) {
//        [self doSaveData:YES];
//        
//    }else {
//        [self doSaveData:NO];
//    }
}

- (IBAction)delete:(id)sender {
    
    [[EventCalendar sharedEventCalendar] deleteEventWithEventIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventIdentifier"]];
    
//    NSError *error_1;
//    
//    
//    NSString *eventIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventIdentifier"];
//
//    EKEvent *event = [self.store eventWithIdentifier:eventIdentifier];
//    
//    [self.store removeEvent:event span:EKSpanFutureEvents commit:YES error:&error_1];
//    
//    if (!error_1) {
//        NSLog(@"删除成功：id：%@",eventIdentifier);
//    }else {
//        NSLog(@"添加失败：%@",error_1);
//    }
}



- (void)doSaveData:(BOOL)authed {
    
    if (!authed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

        });
        return;
    }

    
    EKEvent *event_1 = [EKEvent eventWithEventStore:self.store];
    event_1.title = @"代码创建的日程";
    event_1.calendar = [self.store defaultCalendarForNewEvents];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 1;
    NSDate *endTime = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    event_1.startDate = [NSDate date];
    event_1.endDate = endTime;
    event_1.notes = @"档期详情：hyaction://hunyu-music";
    
    [event_1 addAlarm:[EKAlarm alarmWithAbsoluteDate:<#(nonnull NSDate *)#>]];
    
    NSError *error_1;
    [self.store saveEvent:event_1 span:EKSpanFutureEvents commit:YES error:&error_1];
    if (!error_1) {
        
        NSLog(@"添加成功！id：%@",event_1.eventIdentifier);
        
        [[NSUserDefaults standardUserDefaults] setObject:event_1.eventIdentifier forKey:@"eventIdentifier"];
        
    }else{
        NSLog(@"添加失败：%@",error_1);
    }
}

- (EKEventStore *)store {
    if (!_store) {
        _store = [[EKEventStore alloc] init];
    }
    return _store;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
