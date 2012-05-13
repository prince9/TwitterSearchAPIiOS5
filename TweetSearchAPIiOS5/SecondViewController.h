//
//  SecondViewController.h
//  TweetSearchAPIiOS5
//
//  Created by 真有 津坂 on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController {
    //追加、ツイートされたテキストとユーザ名を受け取って表示する
    NSString *twStr;
    NSString *usernStr;
}

@property (weak, nonatomic) IBOutlet UILabel *sellDetail;
@property (weak, nonatomic) IBOutlet UILabel *userNLabel;

//以下追加
@property (nonatomic,retain) NSString *twStr;
@property (nonatomic,retain) NSString *usernStr;
@property (strong, nonatomic) id detailItem;


@end
