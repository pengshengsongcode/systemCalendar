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
    [[EventCalendar sharedEventCalendar] createEventCalendarTitle:@"彭宝宝" startDate:[NSDate date] endDate:[calendar dateByAddingComponents:components toDate:[NSDate date] options:0] remark:@"啦啦啦啦" orderNo:@"123" operationSucceed:^(BOOL isSucceed) {
        if (isSucceed) {
            
        }
    }];

}

- (IBAction)delete:(id)sender {
    
    [[EventCalendar sharedEventCalendar] deleteEventWithOrderNo:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventIdentifier"] operationSucceed:^(BOOL isSucceed) {
        
        if (isSucceed) {
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
