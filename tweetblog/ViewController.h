//
//  ViewController.h
//  tweetblog
//
//  Created by ありす on 2014/05/04.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "CustomCell.h"
#import "UIImageView+WebCache.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "TweetViewController.h"


@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tweetArray;
    IBOutlet UITableView *tlTableView;
    
    //IBOutlet UILabel *userLabel;
    //IBOutlet UILabel *userIDLabel;
    //IBOutlet UILabel *tweetLabel;
    //IBOutlet UIImageView *userImageView;

    
    //セルのIdentiferを指定
    //UITableViewCell *cell;
    //UITableView *tableView;
    
    //customCell
    CustomCell *_customCell;
    
    //Twitter
    ACAccountStore *account;
    ACAccountType *accountType;
}

-(IBAction)tweetButton;
-(IBAction)refreshButton;

-(void)twitterTL;

@end
