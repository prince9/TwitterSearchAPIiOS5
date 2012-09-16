//
//  ViewController.m
//  TweetSearchAPIiOS5
//
//  Created by 真有 津坂 on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tweetTable;

//以下追加
@synthesize nameLabel;
@synthesize textLabel;
@synthesize tweetIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //以下追加
     //データを受け取る準備をする。receivedDataはTweet全体のデータ、userNameArrayy・tweetTextArray・iconDataArrayはユーザ名・実際のツイート・アイコン
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
 

    
     //追加、これを忘れるとデータが表示できない
    tweetTable.delegate = self;
    tweetTable.dataSource = self;
    
    //TableViewの角を丸くする
    //CALayerでテーブルに影をつけても良いんですが、重いっぽいので今回はUIImageで影をつけたPNGファイルを読み込ませています
    CALayer* layer = self.tweetTable.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0;
    
    [self loadTimeline];

}

- (void)viewDidUnload
{
    [self setTweetTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//追加
- (void)loadTimeline{
	   userNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetTextArray = [[NSMutableArray alloc] initWithCapacity:0];
    iconDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            if (account == nil) {
                NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
                                        account = [accountArray objectAtIndex:0];
                                    }
            if (account != nil) {
                //以下、URLを指定→そこにアクセスする設定をする→アクセスする
                //検索語を指定する。日本語を検索する場合は、UTF-8でURLエンコードした文字列を渡す
                //英語で入力しても大丈夫
                NSString *searchString = @"ペルソナ";
                //UTF-8でURLエンコード
                NSString* encodStr = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //URLを指定
                NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@",encodStr];
                                        
                //URLWithStringでNSURLのインスタンスを生成
                NSURL *url = [NSURL URLWithString:urlString];
                 //NSURLRequestとurlStringで設定したアドレスにアクセスする設定をする
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                //NSURLConnectionで実際にアクセスする
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        NSLog(@"error: %@", [error localizedDescription]);
                        return;
                    }
                    
                    //jsonで解析する
                    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    //resultsにTweetが配列の形で入っている
                    NSArray *tweets = [dictionary objectForKey:@"results"];
                 
                                                          
                    //Tweetをひとつずつ取り出して表示する準備をする
                    for (NSDictionary *tweet in tweets) {
                        [tweetTextArray addObject:[tweet objectForKey:@"text"]];
                        [userNameArray addObject:[tweet objectForKey:@"from_user_name"]];
                        [iconDataArray addObject:[tweet objectForKey:@"profile_image_url"]];
                        
                                                 
                        //ネットワークにアクセスしているマーク
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    [tweetTable reloadData];
                   
                }];
            }
        }
    }];
    
    
}

//追加
//ツイートの数だけテーブルになる
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweetTextArray count];
}

//追加
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //セルのIdentiferを指定
    static NSString *cellID = @"tweetCell";
    //UITableViewCellクラスのインスタンスを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //ユーザ名・ツイート・アイコンを表示するラベルやImageViewにタグを設定する。タグを設定することでどれがどれか識別できる。storyboardの「Tag」で設定してから以下に入力する
    nameLabel = (UILabel*)[cell viewWithTag:1];
    textLabel = (UILabel*)[cell viewWithTag:2];
    tweetIcon = (UIImageView*)[cell viewWithTag:3];
    
    nameLabel.text = [userNameArray objectAtIndex:indexPath.row];
    textLabel.text = [tweetTextArray objectAtIndex:indexPath.row];
    
    textLabel.lineBreakMode  = UILineBreakModeWordWrap;
    textLabel.numberOfLines  = 0;
    
    textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    NSURL *url = [NSURL URLWithString:[iconDataArray objectAtIndex:indexPath.row]];
    NSData *iconData = [NSData dataWithContentsOfURL:url];
    tweetIcon.image = [UIImage imageWithData:iconData];
    
    
    
    return cell;
}

//追加
//次のViewにデータを渡す準備
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mySegue"]) {
        SecondViewController *secondViewController = [segue destinationViewController];
        
        NSInteger selectedIndex = [[self.tweetTable indexPathForSelectedRow] row];
        secondViewController.twStr = [tweetTextArray objectAtIndex:selectedIndex];   
        secondViewController.usernStr = [userNameArray objectAtIndex:selectedIndex];
        
    }
    
    
}


- (IBAction)reloadBtn:(id)sender {
    //以下追加
    [self loadTimeline];
    //ネットワークにアクセスしているマーク
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


@end
