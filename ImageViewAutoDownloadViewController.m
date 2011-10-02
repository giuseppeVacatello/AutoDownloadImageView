//
//  ImageViewAutoDownloadViewController.m
//  ImageViewAutoDownload
//
//  Created by Ignazio Calò on 10/1/11.
//  Copyright 2011 Ignazio Calò. All rights reserved.
//

#import "ImageViewAutoDownloadViewController.h"
#import "AutoDownloadImageView.h"
@implementation ImageViewAutoDownloadViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *str = @"http://www.geom.uiuc.edu/graphics/images/small/Special_Topics/Hyperbolic_Geometry/escher.gif";
	NSURL *url = [NSURL URLWithString:str];
	AutoDownloadImageView *img = [[AutoDownloadImageView alloc]
								  initWithFrame:CGRectMake(0, 0, 100, 100)
								  URL:url
								  persistency:YES
								  forceDownload:NO
								  ];
	[img setDelegate:self];
	[self.view addSubview:img];
}

-(void)autoDownload:(AutoDownloadImageView *)autoDowload didFailWithError:(NSError *)error {
	NSLog(@"SOMETHING WRONG");
}

-(void)autoDownloadImageViewFinishDownloading:(AutoDownloadImageView *)autoDowload {
	NSLog(@"OK");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
