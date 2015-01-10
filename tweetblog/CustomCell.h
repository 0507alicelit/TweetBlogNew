//
//  CustomCell.h
//  tweetblog
//
//  Created by ありす on 2014/08/26.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface CustomCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak,nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak,nonatomic) IBOutlet UIImageView *userImageView;
@property (weak,nonatomic) IBOutlet UIButton *reply;
@property (weak,nonatomic) IBOutlet UIButton *retweet;
@property (weak,nonatomic) IBOutlet UIButton *favorite;

@end
