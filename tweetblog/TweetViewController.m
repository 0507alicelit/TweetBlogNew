//
//  TweetViewController.m
//  tweetblog
//
//  Created by ありす on 2014/12/06.
//  Copyright (c) 2014年 alice. All rights reserved.
//

#import "TweetViewController.h"

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", _idStr) ;
    NSLog(@"%@", _identifier) ;
    //アクセサリビューの作成(メインとフッターの2段構造になってる)
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] ;
    accessoryView.backgroundColor = [UIColor clearColor] ; //透明色
    UIView *accessoryViewFutter = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 5)] ;
    accessoryViewFutter.backgroundColor = [UIColor grayColor] ;
    [accessoryView addSubview:accessoryViewFutter] ;
    //ボタンの作成
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [button setImage:[UIImage imageNamed:@"PullDownButton.png"] forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventTouchUpInside] ;
    button.frame = CGRectMake(281, 22, 40, 30) ;
    [accessoryView addSubview:button] ;
    
    _tweetTextView.inputAccessoryView =  accessoryView ;
    if (_idStr != nil) {
        _tweetTextView.text = [NSString stringWithFormat:@"@%@ ",_name] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEdit:(id)sender{
    [_tweetTextView resignFirstResponder] ;
}

- (IBAction)tweetButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本当にこれでつぶやくのですな？" message:@"口は災いの元" delegate:self cancelButtonTitle:@"やめとくでござる" otherButtonTitles:@"つぶやくでござる", nil] ;
    [alert show] ;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"戻った") ;
    }] ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            NSDictionary *params ;
            if(_idStr != nil){
                params = @{@"status" : _tweetTextView.text, @"in_reply_to_status_id" : _idStr};
                NSLog(@"リプライの方をしたのでござる") ;
            }
            else{
                params = @{@"status" : _tweetTextView.text};
            }
            //            UIImage *image = [UIImage imageNamed:@"blackbird.jpg"];
            //            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            //                        NSData *imageData = UIImagePNGRepresentation(image);
            //            [request addMultipartData:imageData
            //                             withName:@"media[]"
            //                                 type:@"image/png"
            //                             filename:@"blackbird.jpg"];
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
            
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            //  Attach an account to the request
            [request setAccount:account];
            
            UIApplication *application = [UIApplication sharedApplication] ;
            application.networkActivityIndicatorVisible = YES ;
            
            
            //  Execute the request
            [request performRequestWithHandler:^(NSData *responseData,
                                                 NSHTTPURLResponse *urlResponse,
                                                 NSError *error) {
                if (responseData) {
                    NSInteger statusCode = urlResponse.statusCode;
                    if (statusCode >= 200 && statusCode < 300) {
                        NSDictionary *postResponseData =
                        [NSJSONSerialization JSONObjectWithData:responseData
                                                        options:NSJSONReadingMutableContainers
                                                          error:NULL];
                        NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                    }
                    else {
                        NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                              [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                    }
                }
                else {
                    NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIApplication *application = [UIApplication sharedApplication] ;
                    application.networkActivityIndicatorVisible = NO ;
                    [self dismissViewControllerAnimated:YES completion:^(void){
                        NSLog(@"閉じるぜ！") ;
                    }] ;
                }) ;
            }];
        }
            break ;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            NSDictionary *params ;
            NSString *idStr;
            if(idStr != nil){
                //ユーザーが許可した場合
                if(grantpt == YES){
                    
                    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                    if([arrayOfAccounts count] > 0){
                        ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                        NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/create.json"];
                        // 認証が必要な要求に関する設定
                        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                        [parameters setObject:idStr forKey:@"id"];
                        
                        params = @{@"status" : _tweetTextView.text, @"in_reply_to_status_id" : idStr};
                        NSLog(@"リプライの方をしたのでござる") ;
                    }
                    else{
                        params = @{@"status" : _tweetTextView.text};
                    }
                    //            UIImage *image = [UIImage imageNamed:@"blackbird.jpg"];
                    //            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
                    //                        NSData *imageData = UIImagePNGRepresentation(image);
                    //            [request addMultipartData:imageData
                    //                             withName:@"media[]"
                    //                                 type:@"image/png"
                    //                             filename:@"blackbird.jpg"];
                    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                    ACAccount *account = [accountStore accountWithIdentifier:self];//NSString *idStr;
                    
                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                    
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                            requestMethod:SLRequestMethodPOST
                                                                      URL:url
                                                               parameters:params];
                    //  Attach an account to the request
                    [request setAccount:account];
                    
                    UIApplication *application = [UIApplication sharedApplication] ;
                    application.networkActivityIndicatorVisible = YES ;
                    
                    
                    //  Execute the request
                    [request performRequestWithHandler:^(NSData *responseData,
                                                         NSHTTPURLResponse *urlResponse,
                                                         NSError *error) {
                        if (responseData) {
                            NSInteger statusCode = urlResponse.statusCode;
                            if (statusCode >= 200 && statusCode < 300) {
                                NSDictionary *postResponseData =
                                [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
                                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                            }
                            else {
                                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                            }
                        }
                        else {
                            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIApplication *application = [UIApplication sharedApplication] ;
                            application.networkActivityIndicatorVisible = NO ;
                            [self dismissViewControllerAnimated:YES completion:^(void){
                                NSLog(@"閉じるぜ！") ;
                            }] ;
                        }) ;
                    }];
                } else {
                    //NSLog(@"%@",[error localizedDescription]);
                }
            }
        }
            break ;
        default:
            break;
    }
}



@end
