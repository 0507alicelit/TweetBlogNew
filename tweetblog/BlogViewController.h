//
//  BlogViewController.h
//  tweetblog
//
//  Created by ありす on 2014/05/05.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "CalenderViewController.h"

@interface BlogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableDictionary *tweetDictionary;
    // NSMutableArray *tweetDictionary;
    
    NSArray *array;
    IBOutlet UITableView *tlTableView;
}

-(IBAction)waai;

@end
