//
//  CalenderView.m
//  tweetblog
//
//  Created by Kazuki Taniguchi on 2014/05/06.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import "CalenderViewController.h"

@implementation CalenderViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    calendar.frame = CGRectMake(10, 100, 300, 320);
    [self.view addSubview:calendar];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* str = [outputFormatter stringFromDate:date];
    NSLog(@"Date :%@", str);
    NSUserDefaults *dateUd = [NSUserDefaults standardUserDefaults];//設定1
    str = [dateUd stringForKey:@"date"];//設定2
    NSString *ymd = str;
    [dateUd setObject:ymd forKey:@"date"];//設定3
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    
    BlogViewController *blogViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"hoge"];
    [self.navigationController pushViewController:blogViewController animated:NO];
    
    //
    NSDate *tomorrow = [date dateByAddingTimeInterval:86400];
    NSLog(@"tomorrow: %@", [outputFormatter stringFromDate:tomorrow]);
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end