//
//  RootDocNodeVC.m
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


#import "RootDocNodeVC.h"
#import "AppManager.h"
#import "DocumentNode.h"
#import "DocumentContentViewController.h"
#import "DocumentNodeViewController.h"


@implementation RootDocNodeVC

AppManager *appMgr;
DocumentNode *rootNode;
DocumentNode *currChildNode;
NSString *currCellText;

#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
	
    [super viewDidLoad];
	
    appMgr = [AppManager singletonAppManager];
	
    rootNode = appMgr.doc.rootNode;
    self.navigationItem.title = rootNode.text;
	
}


#pragma mark -
#pragma mark Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rootNode getChildNodeCount];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"RootCellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[cell.textLabel setFont:appMgr.tableFont];

    }
    
    // Get the object to display and set the value in the cell.
    DocumentNode *docNode = [rootNode childNodeAtIndex:indexPath.row];
    cell.textLabel.text = docNode.text;
  
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
	
	return cell;
    
}



#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    currChildNode = [rootNode childNodeAtIndex:indexPath.row];
	currCellText = currChildNode.text;
	
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [currCellText sizeWithFont:appMgr.tableFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
    return labelSize.height + 20;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    currChildNode = [rootNode childNodeAtIndex:indexPath.row];
	
	// check for content node which takes a different view controller
    if (currChildNode.type == CONTENT)
	{
		DocumentContentViewController *docContentVC = [[DocumentContentViewController alloc] init];
        
		// Pass the selected object to the new view controller.
		docContentVC.docNode = currChildNode;
		[self.navigationController pushViewController:docContentVC animated:YES];
		[docContentVC release];
        
    } else if (currChildNode.type == HEADER) {
		
        DocumentNodeViewController *docNodeViewController = [[DocumentNodeViewController alloc] init];
        docNodeViewController.docNode = currChildNode;
		
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:docNodeViewController animated:YES];
        [docNodeViewController release];
        
    }    
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

