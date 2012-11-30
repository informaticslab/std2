//
//  ContentVC.m
//  std2
//
//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "ContentVC.h"
#import "AppManager.h"


@implementation ContentVC

@synthesize webView, contentNode;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSString *mimeType = @"text/html";
	NSString *fileExtension = contentNode.contentFileExtension;
	
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSString *theBundlePath = [[NSBundle mainBundle] bundlePath];
    
    if ([fileExtension isEqualToString:@"xhtml"] || [fileExtension isEqualToString:@"html"]) {
        mimeType = @"text/html";
        theBundlePath = [theBundlePath stringByAppendingPathComponent:@"Text"];
    } else if ([fileExtension isEqualToString:@"png"] ) {
        mimeType = @"image/png";
    } else if ([fileExtension isEqualToString:@"jpeg"]) {
        mimeType = @"image/jpeg";	
    }
    
    DebugLog(@"Using bundle path %@", theBundlePath);  
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:contentNode.contentFilePath ofType:contentNode.contentFileExtension];
    DebugLog(@"Content file path = %@", thePath);  
    NSURL *baseURL = [NSURL fileURLWithPath:theBundlePath];
    if (thePath) {
        NSData *htmlData = [NSData dataWithContentsOfFile:thePath];
        [webView loadData:htmlData MIMEType:mimeType
         textEncodingName:@"UTF-8" baseURL:baseURL];
    }
    
    self.navigationItem.title = self.contentNode.text;

	
    
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
