//
//  TweetViewController.h
//  tweetblog
//
//  Created by ありす on 2014/12/06.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ViewController.h"

@interface TweetViewController : UIViewController

@property (copy, nonatomic)NSString *idStr ;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *name ;
- (IBAction)tweetButton:(id)sender;
- (IBAction)back:(id)sender;

@end
