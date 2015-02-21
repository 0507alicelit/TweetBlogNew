//
//  BlogViewController.m
//  tweetblog
//
//  Created by ありす on 2014/05/05.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import "BlogViewController.h"

@implementation BlogViewController

-(IBAction)waai{
    NSLog(@"わーい");
    [self tweetsearch];
}

/*
 -(void)tweetsearch{
 for(int i=0; i<20; i++){
 UILabel *label = [[UILabel alloc] init];
 label.frame = CGRectMake(rand()%280, rand()%540, 100, 20);
 label.text = @"(´・ω・`)";
 [self.view addSubview:label];
 }
 }
 */

///*
-(void)tweetsearch{
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
                 NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 
                 //日付を読み込む
                 //どうやってdate入れるの？？
                 NSUserDefaults *dateUd = [NSUserDefaults standardUserDefaults];//読み込み1
                 NSString *date = [dateUd stringForKey:@"date"];//読み込み2
                 NSLog(@"date %@",date);
                 
                 // 認証が必要な要求に関する設定
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 NSString *paramString = [NSString stringWithFormat:@"from:sj_alice_0507 since:%@ until:2016-05-05", date];
                 [parameters setObject:paramString forKey:@"q"];
                 [parameters setObject:@"20" forKey:@"count"];
                 
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
                     
                     if(response) {
                         if(urlResponse.statusCode == 200) {
                             NSLog(@"success");
                             tweetDictionary = [NSJSONSerialization JSONObjectWithData:response
                                                                               options:NSJSONReadingMutableLeaves
                                                                                 error:&error];
                             if(tweetDictionary.count != 0){
                                 NSLog(@"count != 0");
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [tlTableView reloadData];
                                     for (int i = 0; i < [tweetDictionary count]; i++) {
                                         // 配列から要素を取得する
                                        // NSString *str = [tweetDictionary:[tweetDictionary count]];
                                         //NSLog(@"%@", str);
                                     }
                                 });
                             }
                             
                             array = [tweetDictionary objectForKey:@"statuses"];
                         } else {
                             NSLog(@"error");
                         }
                     }
                 }];
                 
                 //tweet取得完了したらActivity Indicatorを終了
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             }
         } else {
             NSLog(@"%@",[error localizedDescription]);
         }
     }];
}
//*/


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //セルのIdentiferを指定
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell2"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TweetCell2"];
    }
    
    //カプセル上の部品
    UITextView *tweetTextView = (UITextView *)[cell viewWithTag:10];
    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:8];
    
    //セルに表示するtweetのJSONを解析し、NSDictionaryに
    NSMutableDictionary *tweet = [array objectAtIndex:indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    
    //セルにTweetの内容とユーザー名を表示
    [tweetTextView setText:[NSString stringWithFormat:@"%@", tweet[@"text"]]];
    
    //セルにユーザーのimageを表示
    NSString *userImagePath = userInfo[@"profile_image_url"];
    NSURL *userImagePathURL =[[NSURL alloc] initWithString:userImagePath];
    NSData *userImagePathData = [[NSData alloc] initWithContentsOfURL:userImagePathURL];
    userImageView.image = [[UIImage alloc] initWithData:userImagePathData];
    
    return cell;
}


@end
