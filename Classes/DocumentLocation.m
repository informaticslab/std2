//
//  DocumentLocation.m
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


#import "AppManager.h"
#import "DocumentLocation.h"
#import "DocumentNodeViewController.h"
#import "DocumentContentViewController.h"

@implementation DocumentLocation

@synthesize index, destinationNode, nodePath, nodeCount;


AppManager *appMgr;

-(id)initWithNode:(DocumentNode *)newNode 
{
	
	if ((self = [super init]))
	{
		self.destinationNode = newNode;
		nodePath = [[NSMutableArray alloc] init];
		
	}
	
	return self;
	
}



-(void)createNodePath
{
	
	NSMutableArray *nodePathFromBottom = [[NSMutableArray alloc] init];
	DocumentNode *currNode = nil;
	NSInteger reverseIndex = 0;
	
	if (destinationNode != nil) 
	{
		// destination node is first in array
		[nodePathFromBottom addObject:destinationNode];
		currNode = destinationNode;
		
		// work way back up to root node
		while ((currNode.parentNode != nil) && (currNode.type != ROOT))
		{
			[nodePathFromBottom addObject:currNode.parentNode];
			currNode = currNode.parentNode;
			
		}
		
		
		// update node count
		nodeCount = [nodePathFromBottom count];
		
		if (nodeCount) 
		{
			[nodePath removeAllObjects];
			
			reverseIndex = nodeCount - 1;
			
			// store document nodes in top down order
			while (reverseIndex >= 0) 
			{
				currNode = [nodePathFromBottom objectAtIndex:reverseIndex];
				[nodePath addObject:currNode]; 
				DebugLog(@"Adding doc node path: %@", currNode.text);
				reverseIndex--;
				
				
			}
		}
		
	}
    
    [nodePathFromBottom release];
	
}


-(void)pushViewControllers
{
	DocumentNode *currNode;
    
	[self createNodePath];
    
    // go through all the nodes and create right view controller
    for (currNode in nodePath)
    {
        if (currNode.type == ROOT) 
        {
            // add default root view controller
			[appMgr.navController popToRootViewControllerAnimated:NO];
			
			
        } 
        else if (currNode.type == HEADER) 
        {
            
            DocumentNodeViewController *nodeVC = [[DocumentNodeViewController alloc] init];
            nodeVC.docNode = currNode;
			[appMgr.navController pushViewController:nodeVC animated:NO];
			DebugLog(@"Creating Node VC = %@ for doc node %@ ", nodeVC, currNode.text);
            [nodeVC release];
            
        } 
        else if (currNode.type == CONTENT) 
        {
            
            DocumentContentViewController *contentVC = [[DocumentContentViewController alloc] init];
            contentVC.docNode = currNode;
			[appMgr.navController pushViewController:contentVC animated:NO];
			DebugLog(@"Creating Content VC = %@ for doc node %@ ", contentVC, currNode.text);
            [contentVC release];

            
        }
    }
	
	DebugLog(@"Leaving with top VC = %@ ", [appMgr.navController topViewController]);
    
}

- (void)dealloc {
	[self.nodePath release];
    [super dealloc];
}


@end
