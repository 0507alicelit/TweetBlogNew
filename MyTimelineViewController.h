//
//  MyTimelineViewController.h
//  tweetblog
//
//  Created by ありす on 2014/05/05.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface MyTimelineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tweetArray;
    IBOutlet UITableView *tlTableView;
}

-(IBAction)tweetButton;
-(IBAction)refreshButton;

-(void)twitterTL;

@end
