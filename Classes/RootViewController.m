//
//  RootViewController.m
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


#import "RootViewController.h"
#import "RootDocNodeVC.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "SearchVC.h"
#import "ContentTreeVC.h"
#import "EulaViewController.h"
#import "AppManager.h"

@implementation RootViewController

@synthesize cell0, cell1, cell2;

ContentTree *treatmentsContentTree;
ContentTree *imagesContentTree;
ContentTree *referencesContentTree;

AppManager *appMgr;

#pragma mark -
#pragma mark View lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    appMgr = [AppManager singletonAppManager];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentEulaModalView];
    
    
}

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)presentEulaModalView
{
    
    if (appMgr.agreedWithEula == TRUE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@", 
                             [appInfo objectForKey:@"CFBundleShortVersionString"], 
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the 
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed]) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);
        
        // Create the modal view controller
        EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
        eulaVC.delegate = self;
        eulaVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentModalViewController:eulaVC animated:YES];
        
    }
    
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return cell0;
    }
	else if (indexPath.section == 1) {
        return cell1;
		
	}
	else if (indexPath.section == 2) {
        return cell2;
		
	}
	
	// make compiler happy, should never reach here
	return nil;
	
}


- (IBAction)doGuidelines
{
	RootDocNodeVC *rootDocNodeVC = [[RootDocNodeVC alloc] init];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:rootDocNodeVC animated:YES];
	[rootDocNodeVC release];
	
}

- (IBAction)doSearch
{
//	SearchVC *searchVC = [[SearchVC alloc] init];
//	
//	// Pass the selected object to the new view controller.
//	[self.navigationController pushViewController:searchVC animated:YES];
//	[searchVC release];
	
}

- (IBAction)doTreatments
{
    
    if (treatmentsContentTree == nil) {
        treatmentsContentTree = [[ContentTree alloc] initWithFilePath:@"treatments" fileType:@"txt"];
    }
    
    
    ContentTreeVC *contentTreeVC = [[ContentTreeVC alloc] initWithContentTree:treatmentsContentTree];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:contentTreeVC animated:YES];
	[contentTreeVC release];
    
}

- (IBAction)doSymptoms
{
	
}

- (IBAction)doImageLibrary
{
    if (imagesContentTree == nil) {
        imagesContentTree = [[ContentTree alloc] initWithFilePath:@"images" fileType:@"txt"];
    }
    
    ContentTreeVC *contentTreeVC = [[ContentTreeVC alloc] initWithContentTree:imagesContentTree];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:contentTreeVC animated:YES];
	[contentTreeVC release];
	
}

- (IBAction)doGlossary
{
	
}

- (IBAction)doReference
{
    if (referencesContentTree == nil) {
        referencesContentTree = [[ContentTree alloc] initWithFilePath:@"references" fileType:@"txt"];
    }
    
    ContentTreeVC *contentTreeVC = [[ContentTreeVC alloc] initWithContentTree:referencesContentTree];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:contentTreeVC animated:YES];
	[contentTreeVC release];
	
}

- (IBAction)doAbout
{
	AboutViewController *aboutVC = [[AboutViewController alloc] init];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:aboutVC animated:YES];
	[aboutVC release];
	
	
}

- (IBAction)doHelp
{

    HelpViewController *helpVC = [[HelpViewController alloc] init];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:helpVC animated:YES];
	[helpVC release];
	
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

