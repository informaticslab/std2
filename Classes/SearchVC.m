//
//  SearchModalView.m
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


#import "SearchVC.h"
#import "AppManager.h"
#import "DocumentNode.h"
#import "DocumentLocation.h"

@implementation SearchVC


@synthesize listContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize tv, sb, context;

AppManager *appMgr;


#define HEADER_LABEL_TAG 1
#define CONTENT_LABEL_TAG 2

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    
	[super viewDidLoad];

	appMgr = [AppManager singletonAppManager];
	
	// Create the master list for the main view controller.
	NSArray *content = appMgr.doc.allNodes;

	
	self.listContent = content;
	self.title = @"Keyword Search";
    
    // create search context
    self.context = [[SearchContext alloc] init]; 
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tv reloadData];
	self.tv.scrollEnabled = YES;

	self.sb.showsSearchResultsButton = NO;
	    
}

- (void)viewDidUnload
{

	[self.context clearAll];

}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}


- (void)dealloc
{
	//[listContent release];
	//[context release];
	//[tv release];
	
    // TODO fix this !!!
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.context matchCount];
    }
	else
	{
        return [self.listContent count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return 80.0; //returns floating point which will be used for a cell row height at specified row index  
}  



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";   
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];

    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:11];
		cell.detailTextLabel.numberOfLines = 4;
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
    

	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	DocumentNode *docNode = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		SearchMatch *match = [self.context getSearchMatchAtIndex:indexPath.row];
		docNode = match.docNode;
		cell.textLabel.text = [NSString stringWithFormat:@"Found in section: %@", docNode.parentNode.text];
		cell.detailTextLabel.text = match.text;
		
		if (match.matchType == HEADER_MATCH) 
		{
			UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"big_H" ofType:@"png"]];
			cell.imageView.image = image;
			
		}
		else if (match.matchType  == CONTENT_MATCH)
		{
			UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"big_C" ofType:@"png"]];
			cell.imageView.image = image;

		}
    }
	else
	{
        docNode = [self.listContent objectAtIndex:indexPath.row];
		cell.textLabel.text = docNode.text;
    }
	

	return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	DocumentNode *docNode = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		
        docNode = [self.context getSearchMatchAtIndex:indexPath.row].docNode;
        DocumentLocation *docLocation = [[DocumentLocation alloc] initWithNode:docNode];
		[docLocation pushViewControllers];
        [docLocation release];

    }
	else
	{
        UIViewController *detailsViewController = [[UIViewController alloc] init];
        docNode = [self.listContent objectAtIndex:indexPath.row];
		detailsViewController.title = docNode.text;
		
		[[self navigationController] pushViewController:detailsViewController animated:YES];
		[detailsViewController release];
    }
}


#pragma mark -
#pragma mark Content Filtering


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// require a minimum of three characters before searching
	if ([searchText length] < 3) {
		[self.context clearAll]; 
		[self.searchDisplayController.searchResultsTableView reloadData];
		return;
	}
	
    // update the filtered array based on the search text & scope
    
    // clear the filtered array
	[self.context clearAll]; 
	
	// search the document node list for nodes whose Type matches the scope (if selected) and whose text field matches searchText
    // then add items that match to the filtered array.
	self.context.searchString = searchText;
    if ([scope isEqualToString:@"All"])
        self.context.nodeTypes = ALL_NODE_TYPES;
    else if ([scope hasPrefix:@"Hea"])
         self.context.nodeTypes = HEADER;
    else if ([scope hasPrefix:@"Con"])
         self.context.nodeTypes = CONTENT;
    [appMgr.doc searchForText:self.context];
    
    
}

// old method
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    // update the filtered array based on the search text & scope
//
//    // clear the filtered array
//	[self.filteredListContent removeAllObjects]; 
//	
//	// search the document node list for nodes whose Type matches the scope (if selected) and whose text field matches searchText
//    // then add items that match to the filtered array.
//    for (DocumentNode *docNode in listContent)
//	{
//        
//		if ([scope isEqualToString:@"All"] )
//		{
//			NSComparisonResult result = [docNode.text compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.filteredListContent addObject:docNode];
//            }
//		}
//	}
//}
//

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	// require a minimum of three characters before searching
	if ([searchString length] < 3) {
		[self.context clearAll]; 
		[self.searchDisplayController.searchResultsTableView reloadData];
		return NO;
	}
	
    NSLog(@"search display controller = %@", self.searchDisplayController);
    NSLog(@"search bar = %@", self.searchDisplayController.searchBar);
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
	
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some 
    // api that you are using to do the search
//    NSArray *results = [SomeService doSearch:searchBar.text];
	
  //  [self searchBar:searchBar activate:NO];
	
//    [self.tableData removeAllObjects];
//    [self.tableData addObjectsFromArray:results];
//    [self.theTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

	
}

@end

