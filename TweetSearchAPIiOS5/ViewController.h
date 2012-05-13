//
//  ViewController.h
//  TweetSearchAPIiOS5
//
//  Created by 真有 津坂 on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//以下追加
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>

//追加
@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    //NSMutableDataは変更可能な文字列(文字列を追加していきたい場合やデータの保持など)を使う
    //以下追加
    NSMutableArray *userNameArray;
    NSMutableArray *tweetTextArray;
    NSMutableArray *iconDataArray;
 
    
    ACAccount *account;
    ACAccountType *accountType;
    ACAccountStore *accountStore;
    
    //nameLabel・textLabel・tweetIconの3つはstoryboardでひも付けしないこと
    UILabel *nameLabel;
    UILabel *textLabel;
    UIImageView *tweetIcon;
    
    
}

//TableViewはstoryboardでひも付ける(TableViewの中に設置するものはひも付けしないでタグで指定する)
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;

//以下追加
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) UIImageView *tweetIcon;

//リロードボタン、追加
- (IBAction)reloadBtn:(id)sender;

//追加
- (void)loadTimeline;

@end
