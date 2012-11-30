//
//  SearchContext.m
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


#import "SearchContext.h"


@implementation SearchContext

@synthesize allMatches;
@synthesize searchString, nodeTypes;

-(id)init
{
    
	if ((self = [super init]))
    {
        self.allMatches = [[NSMutableArray alloc] init];        
    }
    
    return self;

}


-(void)addSearchMatch:(SearchMatch *)match
{
	
	[self.allMatches addObject:match];
	
}

-(SearchMatch *)getSearchMatchAtIndex:(NSUInteger)index
{
	SearchMatch *match = NULL;
	
	if (allMatches != NULL)
	{
		if ([allMatches count] != 0) 
		{
			if (index < [allMatches count]) 
			{
				match =  [allMatches objectAtIndex:index];
			}
			
		}
	}
	
	return match;
}

-(NSUInteger)matchCount
{

	return [allMatches count];
	
}

-(void)clearAll
{
	[allMatches removeAllObjects];
	
}

@end