//
//  DocumentNode.m
//  StdGuide
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


#import "DocumentNode.h"
#import "AppManager.h"

@implementation DocumentNode
@synthesize text, type, childNodes, parentNode;
@synthesize contentFilePath, contentText;

#define MATCH_STRING_PADDING 45

-(id)initWithTextTypeContentFile:(NSString *)nodeText nodeType:(DocumentNodeType)nodeType contentFile:(NSString *)content
{
	
	if ((self = [super init]))
	{
		self.text = nodeText;
		self.type = nodeType;
        self.contentFilePath = content;
        
	}
	
	return self;
	
}

-(void)loadContentText
{
	NSString *rawText = [self readAppBundleTextFile];
	self.contentText =  [self removeHtmlTags:rawText];
}

-(id)initWithTextAndType:(NSString *)nodeText nodeType:(DocumentNodeType)nodeType 
{
    return [self initWithTextTypeContentFile:nodeText nodeType:nodeType contentFile:NULL];
     
}

-(NSString *)readAppBundleTextFile
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.contentFilePath 
                                                     ofType:@"xhtml"];    
    
    NSString *rawText = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return rawText;
    
}

-(NSUInteger)getChildNodeCount
{
    
	if (self.childNodes != NULL) {
		return [self.childNodes count];
	}
	else {
		return (NSUInteger)0;
	}

}

-(void)addChildDocumentNode:(DocumentNode *)childNode
{
	DebugLog("adding child node %@ to node %@", childNode, self);
    if (self.childNodes == NULL)
        self.childNodes = [[NSMutableArray alloc] init];
	childNode.parentNode = self;
	[self.childNodes addObject:childNode];	

}

-(NSArray *)getChildNodes
{
	
	NSArray *allChildNodes = self.childNodes;
	return allChildNodes;
 
}

-(void)addChildNodesToArray:(NSMutableArray *)destArray
{
    DocumentNode *child;
	
	// check for any nodes
	if (self.childNodes != NULL)
	{
		// add child nodes
		for(child in self.childNodes) 
        {
			// add child to array
			[destArray addObject:child];

			// add child's children to array
			[child addChildNodesToArray:destArray];
        }
	}
	
}

-(DocumentNode *)childNodeAtIndex:(NSUInteger)index
{
    if ((childNodes == NULL) || ([childNodes count] < index))
        return NULL;
    else
        return [childNodes objectAtIndex:index];

}

-(BOOL)hasChildContentNode
{
	if ([self.childNodes count] == 1) {
		DocumentNode *node = [self.childNodes objectAtIndex:0];
		if (node.type == CONTENT)
			return YES;
	}

	return NO;
	
}

-(BOOL)isContentNode
{
	if (self.type == CONTENT)
		return YES;
	else 
		return NO;
	
}

-(void)printChildNodes
{
    DocumentNode *child;
    int count = 0;
    DebugLog(@"Print child nodes for %@.", self.text);
    
    // print all child nodes
    if (childNodes != NULL)
    {
        for(child in self.childNodes) 
        {
            [child printChildNodes];
            
            DebugLog(@"Child node at index %d of %@ is %@", count++, self.text, child.text);

        }
    } else {
        DebugLog(@"No child nodes exist.");

    }
    
}

- (void)searchForText:(SearchContext *)context
{
	
	DocumentNode *child;

	// conduct search on self
    if ((self.type == CONTENT) && ((context.nodeTypes == CONTENT) || (context.nodeTypes == ALL_NODE_TYPES)))
    {
        [self searchForContentText:context];
    } 
    //else if ((self.type == HEADER) && ((context.nodeTypes == HEADER) || (context.nodeTypes == ALL_NODE_TYPES))) 
	else if ((context.nodeTypes == HEADER) || (context.nodeTypes == ALL_NODE_TYPES)) 
    {
        [self searchForHeaderText:context];
	}
	
	// conduct search on child nodes
    if (childNodes != NULL)
    {
        for(child in self.childNodes) 
        {
            [child searchForText:context];
		}
	}
			
}

-(void)searchForHeaderText:(SearchContext *)context
{

	if ([[self.text lowercaseString] rangeOfString:[context.searchString lowercaseString]].location == NSNotFound)
		return;
	
	SearchMatch *newMatch = [[SearchMatch alloc] initWithNode:self matchType:HEADER_MATCH];
	newMatch.text = self.text;
	DebugLog(@"Header match string =  %@", self.text);
		
	[context addSearchMatch:newMatch];
    [newMatch release];
	return;

}


- (void)searchForContentText:(SearchContext *)context
{
    NSScanner *scanner;
    NSInteger index = 0;
    NSUInteger startIndex, endIndex;
    NSString *matchText;
    NSRange range;
	SearchMatch *newMatch;
    
	// load raw text file
	if (self.contentText == nil) 
		[self loadContentText];
	
	scanner = [NSScanner scannerWithString:self.contentText];
        
    // remove all markup before start body tag
    while ([scanner isAtEnd] == NO) {
        
        
        // find search text
        [scanner scanUpToString:context.searchString intoString:NULL]; 
        
        // if scanner is not at end
        if ([scanner isAtEnd] == NO ) {
            index = [scanner scanLocation];
            
            if ((index - MATCH_STRING_PADDING) > 0)
                startIndex = index - MATCH_STRING_PADDING;
            else 
                startIndex = 0;
            
            if ((index + MATCH_STRING_PADDING) < [self.contentText length])
                endIndex = index + MATCH_STRING_PADDING;
            else 
                endIndex = [self.contentText length];
            
            range = NSMakeRange(startIndex, endIndex - startIndex); 
            matchText = [self.contentText substringWithRange:range];

            DebugLog(@"Content match string =  %@", matchText);
			
			// create SearchMatch object and add to SearchContext collection
			newMatch = [[SearchMatch alloc] initWithNode:self  matchType:CONTENT_MATCH];
			newMatch.text = matchText;
			newMatch.stringIndex = index;
			
			[context addSearchMatch:newMatch];
            [newMatch release];
			
        }
        
        [scanner scanString:context.searchString intoString:NULL]; 
        
        
    } // while //
        
    
}

- (NSString *)removeHtmlTags:(NSString *)html 
{
    
    NSScanner *scanner;
    NSString *unwantedTags = nil;
    
    
    scanner = [NSScanner scannerWithString:html];
    
    [scanner scanUpToString:@"<body>" intoString:&unwantedTags] ; 
        
    // replace the found tag with a space
    //(you can filter multi-spaces out later if you wish)
    html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@", unwantedTags]
                                               withString:@""];
        
    // remove all markup before start body tag
    while ([scanner isAtEnd] == NO) {
        

        // find start of tag
        [scanner scanUpToString:@"<" intoString:NULL] ; 
        
        // find end of tag
        [scanner scanUpToString:@">" intoString:&unwantedTags] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", unwantedTags]
                                               withString:@" "];
        
    } // while //
    
    DebugLog(@"HTML string: %@", html);
    return html;
    
}


@end
