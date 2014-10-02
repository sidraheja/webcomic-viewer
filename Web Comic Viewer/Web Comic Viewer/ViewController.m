//
//  ViewController.m
//  Web Comic Viewer
//
//  Created by Sid Raheja on 9/28/14.
//  Copyright (c) 2014 SidApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _notOptimize = true;
    if(_allComics == true)
    {
        _comicNumber = arc4random() % 1300;
        if(_comicNumber == 0)
        {
            _comicNumber = 1;
        }
        [self LoadComicView:_comicNumber];
    }
    else
    {
        _comicNumber = [self findComicId];
        _allComics = true;
        [self LoadComicView:_comicNumber];
        _allComics = false;
    }

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prevComic:(id)sender
{
    if(_allComics)
    {
        _comicNumber = _comicNumber - 1;
        if(_comicNumber == 1)
        {
            _comicNumber = 1300;
        }
        [self LoadComicView:_comicNumber];
    }
    else
    {
        _comicNumber = [self findComicId];
        _allComics = true;
        [self LoadComicView:_comicNumber];
        _allComics = false;
    }
}

- (IBAction)nextComic:(id)sender
{
    if(_allComics)
    {
        _comicNumber = _comicNumber + 1;
        if(_comicNumber == 1300)
        {
            _comicNumber = 1;
        }
        [self LoadComicView:_comicNumber];
    }
    else
    {
        NSLog(@"HERE!");
        _comicNumber = [self findComicId];
        _allComics = true;
        [self LoadComicView:_comicNumber];
        _allComics = false;
    }
}

-(void)LoadComicView:(int)comicNumber
{
    NSString *apiString = [NSString stringWithFormat:@"http://xkcd.com/%d/info.0.json",comicNumber]; //Set up string with url
    NSURL *apiURL = [[NSURL alloc] initWithString:apiString];  //Set up url to access the api
    NSError *err;
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:apiURL];  //set up the url request
    NSData *comicData = [NSURLConnection sendSynchronousRequest:urlRequest  //send synchronous request to get data from the url
                                             returningResponse:nil
                                                         error:&err];
    if (err)
    {
        NSLog(@"ERROR!");
        //Set up error message
    }
    id jsonObj = [NSJSONSerialization JSONObjectWithData:comicData
                                                 options:NSJSONReadingMutableLeaves   //get the data in a JSON object
                                                   error:&err];
    if (err)
    {
        NSLog(@"ERROR!");
        //set up error message
    }
    
    NSLog(@"image url is: %@",[jsonObj objectForKey:@"img"]);
    NSURL *comicImageURL = [NSURL URLWithString:[jsonObj objectForKey:@"img"]];
    NSData *comicImageData = [NSData dataWithContentsOfURL:comicImageURL];   //Get the image from a url in a data object
    UIImage *comicImage = [[UIImage alloc] initWithData:comicImageData];
    if(_allComics)
    {
        CGSize iSize = CGSizeMake(_comicView.frame.size.width, _comicView.frame.size.height);
        comicImage = [self resizeImage:comicImage imageSize:iSize];
        _comicView = [_comicView initWithImage:comicImage];
    }
    else
    {
        if(fabsf((comicImage.size.height - comicImage.size.width)) <= 200 || fabsf((comicImage.size.width - comicImage.size.height)) <= 100)
        {
            NSLog(@"Image height is: %f", comicImage.size.height);
            NSLog(@"Image width is: %f", comicImage.size.width);

            _notOptimize = false;
        }
    }

}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    if(image.size.width > 1.5 * image.size.height)
    {
         [image drawInRect:CGRectMake(0,0,size.width * .9,size.height * .5)];
    }
    else if(image.size.width > 1.2 * image.size.height)
    {
        [image drawInRect:CGRectMake(0,0,size.width * .95,size.height * .7)];
    }
    else if(image.size.width >= 1.05 * image.size.height)
    {
         [image drawInRect:CGRectMake(0,0,size.width * .99,size.height * .85)];
    }
    else
    {
        [image drawInRect:CGRectMake(0,0,size.width * .99,size.height * .99)];
    }
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}

-(int)findComicId
{
    _notOptimize = TRUE;
    while(_notOptimize)
    {
        NSLog(@"Optimized: %d", _notOptimize);
        NSLog(@"HELLO");
        _comicNumber = arc4random() % 1300;
        [self LoadComicView:_comicNumber];
    }
    return _comicNumber;
}


- (IBAction)home:(id)sender
{
    homeViewController *home = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:home animated:NO completion:nil];

}



@end
