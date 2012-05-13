//
//  SecondViewController.m
//  TweetSearchAPIiOS5
//
//  Created by 真有 津坂 on 12/05/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
//追加
- (void)configureView;
@end

@implementation SecondViewController
@synthesize sellDetail;

//以下追加
@synthesize detailItem;
@synthesize userNLabel;
@synthesize twStr;
@synthesize usernStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//追加
- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

//追加
- (void)configureView
{
    // Update the user interface for the detail item.
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //以下追加
    [self configureView];
    self.sellDetail.text = twStr;
    self.userNLabel.text = usernStr;

}

- (void)viewDidUnload
{
    [self setSellDetail:nil];
    [self setUserNLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
