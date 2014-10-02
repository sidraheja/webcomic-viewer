//
//  ViewController.h
//  Web Comic Viewer
//
//  Created by Sid Raheja on 9/28/14.
//  Copyright (c) 2014 SidApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeViewController.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *comicView;
@property int comicNumber;
@property BOOL allComics;
@property BOOL notOptimize; 

@end
