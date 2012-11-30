//
//  ContentTreeVC.m
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


#import "ContentTreeVC.h"
#import "AppManager.h"
#import "ContentNodeVC.h"
#import "ContentVC.h"

@implementation ContentTreeVC

AppManager *appMgr;

@synthesize contentTree;

#pragma mark -
#pragma mark Initialization
-(id)initWithContentTree:(ContentTree *)theContentTree
{
    // set content tree for view controller
	if ((self = [super init]))
	{
        self.contentTree = theContentTree;

    }

    return self;

}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
	
    appMgr = [AppManager singletonAppManager];
    self.navigationItem.title = self.contentTree.rootNode.text;
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




#pragma mark -
#pragma mark Table view data source
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentTree.rootNode getChildNodeCount];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"ContentTreeVC";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Get the object to display and set the value in the cell.
    ContentNode *contentNode = [self.contentTree.rootNode childNodeAtIndex:indexPath.row];
    cell.textLabel.text = contentNode.text;
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentNode *contentNode = [self.contentTree.rootNode childNodeAtIndex:indexPath.row];
	
	// check for content node which takes a different view controller
    if ((contentNode.type == CONTENT_NODE_TYPE_HTML_CONTENT) || (contentNode.type == CONTENT_NODE_TYPE_IMAGE_CONTENT)) 
	{
		ContentVC *contentVC = [[ContentVC alloc] init];
        
		// Pass the selected object to the new view controller.
		contentVC.contentNode = contentNode;
		[self.navigationController pushViewController:contentVC animated:YES];
		[contentVC release];
        
    } else if (contentNode.type == CONTENT_NODE_TYPE_HEADING) {
		
        ContentNodeVC *contentNodeVC = [[ContentNodeVC alloc] init];
        contentNodeVC.contentNode = contentNode;
		
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:contentNodeVC animated:YES];
        [contentNodeVC release];
        
    }    
}


#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [super dealloc];
}




@end
