//
//  ViewController.m
//  tweetblog
//
//  Created by ありす on 2014/05/04.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import "ViewController.h"
#define MAX_HEIGHT 2000
#define WIDTH 202

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self twitterTL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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

//教科書p13
-(void)twitterTL{
    //STEP1 ios内部に保存されてるアカウント情報を取得
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
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
    //セルのIdentiferを指定
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    //カプセル上の部品
    UILabel *userLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *userIDLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *tweetLabel = (UILabel *)[cell viewWithTag:3];
    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:4];
    
    //セルに表示するtweetのJSONを解析し、NSDictionaryに
    NSDictionary *tweet = tweetArray[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    
    //セルにTweetの内容とユーザー名を表示
    tweetLabel.text = [NSString stringWithFormat:@"%@",tweet[@"text"]];
    
    //最適な高さを調べる
    CGSize maxSize = CGSizeMake(202,1000);
    CGSize tweetLabelSize = [tweetLabel sizeThatFits:maxSize];
    
    
    //NSLog(@"label座標  %@", NSStringFromCGSize(tweetLabelSize));
    tweetLabel.frame = CGRectMake(93,68,tweetLabelSize.width, tweetLabelSize.height);
    
    userLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
    userIDLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"screen_name"]];
    
    //セルにユーザーのimageを表示
    NSString *userImagePath = userInfo[@"profile_image_url"];
    NSURL *userImagePathURL =[[NSURL alloc] initWithString:userImagePath];
    NSData *userImagePathData = [[NSData alloc] initWithContentsOfURL:userImagePathURL];
    userImageView.image = [[UIImage alloc] initWithData:userImagePathData];
    
    CGSize cellmaxSize = CGSizeMake(360,1000);
    CGSize cellSize = [tweetLabel sizeThatFits:cellmaxSize];
    cellSize = CGSizeMake(cellSize.width,cellSize.height+50);
    NSLog(@"user %@", userInfo[@"name"]);
    NSLog(@"cell座標  %@", NSStringFromCGSize(cellSize));
    NSLog(@"cell x %f", cell.frame.origin.x);
    NSLog(@"cell y %f", cell.frame.origin.y);
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y,cellSize.width, cellSize.height);
    return cell;
     
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[self tableView:tlTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
    
}

@end









