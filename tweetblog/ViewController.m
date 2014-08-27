//
//  ViewController.m
//  tweetblog
//
//  Created by ありす on 2014/05/04.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import "ViewController.h"
#import "RZCellSizeManager.h"
#define MAX_HEIGHT 2000
#define WIDTH 202

@interface ViewController ()

@property (strong, nonatomic) NSArray *objects;  // Cellで使用するデータ
@property (strong, nonatomic) RZCellSizeManager *sizeManager;  // RZCellSizeManagerのインスタンス

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
//    // RZCellSizeManagerの初期化
//    _sizeManager = [[RZCellSizeManager alloc] init];
//    
//    // RZCellSizeManagerにカスタムセルの登録
//    [_sizeManager registerCellClassName:NSStringFromClass([TweetCell class])
//                           withNibNamed:nil
//                     forReuseIdentifier:@"CustomCell"
//                 withConfigurationBlock:^(CustomCell *cell, SomeObject *object) {
//                     // カスタムセルに値をセットしてレイアウト変更する
//                     cell.someObject = object;
//                 }];
    
    //cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
     _customCell = (CustomCell *)[tlTableView dequeueReusableCellWithIdentifier:@"TweetCell"]; // 追加
    
    [self getAccount];
    
    [self twitterTL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tweetArray count];
}

-(IBAction)tweetButton{
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

-(IBAction)refreshButton{
    [self twitterTL];
}

-(void)getAccount{
    //STEP1 ios内部に保存されてるアカウント情報を取得
    account = [[ACAccountStore alloc] init];
    accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

}

//教科書p13
-(void)twitterTL{
    //ユーザーにTwitterの認証情報を使うことを確認
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted,NSError *error)
     {
         //ユーザーが許可した場合
         if(granted == YES){
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if([arrayOfAccounts count] > 0){
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                 // 認証が必要な要求に関する設定
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"100" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 
                 //　リクエストを生成
                 SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:requestAPI
                                                          parameters:parameters
                                     ];
                 
                 // リクエストに認証情報を付加
                 posts.account = twitterAccount;
                 //ステータスバーのActivity Indicatorを開始
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 //リクエストを発行
                 [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error){
                     //STEP3 JSON配列を解析し、tweetをNSArrayの配列に入れる
                     tweetArray = [NSJSONSerialization JSONObjectWithData:response
                                                                  options:NSJSONReadingMutableLeaves
                                                                    error:&error];
                     if(tweetArray.count != 0){
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [tlTableView reloadData];
                         });
                     }
                     NSLog(@"%@",[tweetArray class]);
                 }];
                 //tweet取得完了したらActivity Indicatorを終了
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             }
         } else {
             NSLog(@"%@",[error localizedDescription]);
         }
     }];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TweetCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *customCell = (CustomCell *)cell;
    
    //セルに表示するtweetのJSONを解析し、NSDictionaryに
    NSDictionary *tweet = tweetArray[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    
    //セルにTweetの内容とユーザー名を表示
    customCell.tweetLabel.text = [NSString stringWithFormat:@"%@",tweet[@"text"]];
    
    customCell.userNameLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
    customCell.userIDLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"screen_name"]];
    
    //セルにユーザーのimageを表示
    NSString *userImagePath = userInfo[@"profile_image_url"];
    NSURL *userImagePathURL =[[NSURL alloc] initWithString:userImagePath];
    NSData *userImagePathData = [[NSData alloc] initWithContentsOfURL:userImagePathURL];
    customCell.userImageView.image = [[UIImage alloc] initWithData:userImagePathData];
    
    [customCell.reply addTarget:self action:@selector(pushReply:event:)
            forControlEvents:UIControlEventTouchUpInside];
    [customCell.retweet addTarget:self action:@selector(pushRetweet:event:)
               forControlEvents:UIControlEventTouchUpInside];
    [customCell.favorite addTarget:self action:@selector(pushFavorite:event:)
               forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    [self configureCell:_customCell atIndexPath:indexPath];
    [_customCell layoutSubviews];
    CGFloat height = [_customCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(void)pushReply: (UIButton *)sender
           event:(UIEvent *)event{
    // 押されたボタンのセルのインデックスを取得
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:tlTableView];
    NSIndexPath *indexPath = [tlTableView indexPathForRowAtPoint:point];
    
    // ログを出力
    NSLog(@"Reply row : %d", indexPath.row);
}

-(void)pushRetweet: (UIButton *)sender
           event:(UIEvent *)event{
    // 押されたボタンのセルのインデックスを取得
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:tlTableView];
    NSIndexPath *indexPath = [tlTableView indexPathForRowAtPoint:point];
    
    // ログを出力
    NSLog(@"Retweet row : %d", indexPath.row);
}

-(void)pushFavorite: (UIButton *)sender
           event:(UIEvent *)event{
    // 押されたボタンのセルのインデックスを取得
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:tlTableView];
    NSIndexPath *indexPath = [tlTableView indexPathForRowAtPoint:point];
    
    // ログを出力
    NSLog(@"Favorite row : %d", indexPath.row);
}



@end









