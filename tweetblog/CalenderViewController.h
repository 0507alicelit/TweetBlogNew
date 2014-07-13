//
//  CalenderView.h
//  tweetblog
//
//  Created by Kazuki Taniguchi on 2014/05/06.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CKCalendarView.h"
#import "BlogViewController.h"

@interface CalenderViewController : UIViewController <CKCalendarDelegate>

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end
