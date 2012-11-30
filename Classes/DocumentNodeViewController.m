//
//  DocumentNodeViewController.m
//  Std-Guide
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


#import "DocumentNodeViewController.h"
#import "DocumentContentViewController.h"
#import "AppManager.h"
@implementation DocumentNodeViewController

@synthesize docNode;

AppManager *appMgr;
NSString *currCellText;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
  
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:UITableViewCellStyleDefault])) 
	{
		
    }
    return self;
    
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	appMgr = [AppManager singletonAppManager];


    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//    [iButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
	//    UIBarButtonItem *iButtonItem = [[UIBarButtonItem alloc] initWithCustomView: iButton];
	//    self.navigationItem.rightBarButtonItem = iButtonItem;
	//    [iButtonItem release];
	
	// Uncomment the following line to display an edit button in the navigation bar for this view controller.
	UIBarButtonItem *btnFlexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [iButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *iButtonItem = [[UIBarButtonItem alloc] initWithCustomView: iButton];
    self.toolbarItems = [[NSArray alloc] initWithObjects:btnSearch, btnFlexSpace, iButtonItem, nil];
    [iButtonItem release];
    [btnSearch release];
    [btnFlexSpace release];
	
    
    self.navigationItem.title = self.docNode.text;
    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.docNode getChildNodeCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentNode *currDocNode = [self.docNode childNodeAtIndex:indexPath.row];
	currCellText = currDocNode.text;

    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [currCellText sizeWithFont:appMgr.tableFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
    return labelSize.height + 20;
	 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"DocumentNodeCellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[cell.textLabel setFont:appMgr.tableFont];

    }
    
    // Get the object to display and set the value in the cell.
    DocumentNode *currDocNode = [self.docNode childNodeAtIndex:indexPath.row];
	currCellText = currDocNode.text;
    cell.textLabel.text = currDocNode.text;
	
	
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    
	return cell;
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// get reference to selected document node
    DocumentNode *selDocNode = [self.docNode childNodeAtIndex:indexPath.row];

	// check for content node which takes a different view controller
    if (selDocNode.type == CONTENT)
	{
		DocumentContentViewController *docContentVC = [[DocumentContentViewController alloc] init];

		// Pass the selected object to the new view controller.
		docContentVC.docNode = selDocNode;
		[self.navigationController pushViewController:docContentVC animated:YES];
		[docContentVC release];
		
	} else if (selDocNode.type == HEADER) {
		
		DocumentNodeViewController *docNodeVC = [[DocumentNodeViewController alloc] init];

		// Pass the selected object to the new view controller.
		docNodeVC.docNode = selDocNode;
		[self.navigationController pushViewController:docNodeVC animated:YES];
		[docNodeVC release];
		

	}
    
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

