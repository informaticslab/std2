//
//  DocumentMap.m
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


#import "DocumentMap.h"

@implementation DocumentMap

@synthesize csvAsArray, csvAsString, rootNode;

-(id)init
{
	
	// open document map file and read in lines of text
	if ((self = [super init]))
	{
		NSLog(@"Opening document map file.");
		self.csvAsString = [self readDocumentMapFile];
        
		NSLog(@"Parsing document map file.");
		self.csvAsArray = [self parse:self.csvAsString];
		
		NSLog(@"Creating document nodes.");
        self.rootNode = [self createDocumentNodes];
	}
	return self;
	
}


-(void)printCsvArray
{
    NSArray *row;
    NSString *column;
    
    for (row in self.csvAsArray) 
    {

        for (column in row)
        {
            DebugLog(@" row, column csv value = %@", column);
        }
        
    }
    
}


-(DocumentNode *)createDocumentNodes
{
	
	NSArray *currNodeAsArray;
	NSString *currAttribute;
	NSMutableArray *parentNodes;
	NSUInteger attributeIndex = 0;
	int nodeIndex = 0;
    DocumentNode *lastNode;
	DocumentNode *currNode = nil;
	DocumentNodeType currNodeType = UNDEFINED_NODE_TYPE;
    NSString *currNodeText = nil;
    NSString *currNodeContentFile = nil;
    short currNodeLevel = 0;
    short lastNodeLevel = 0; 
//    BOOL validNode = NO;
	NSString *txtFileDir = @"Text";
    
	
	parentNodes = [[NSMutableArray alloc] init];
	lastNode = nil;
    
	// for every node in CSV array
	for (currNodeAsArray in self.csvAsArray) 
	{
		DebugLog(@"processing node %d", nodeIndex);
        attributeIndex = 0;//
//        validNode = NO;
        
		// get all attributes for node
		for (currAttribute in currNodeAsArray)
		{
            // get heading level first
            DebugLog(@" row, column csv value = %@", currAttribute);
            switch (attributeIndex++) {
                    
                    // document node level attribute 
                case 0:
                    currNodeLevel = [currAttribute intValue];
                    DebugLog(@"current node level = %d", currNodeLevel);
                    break;
                    
                    // node type attribute
                case 1:
                    if ([currAttribute isEqualToString:@"root"])
                        currNodeType = ROOT;
                    else if ([currAttribute isEqualToString:@"header"])
                        currNodeType = HEADER;
                    else if ([currAttribute isEqualToString:@"content"])
                        currNodeType = CONTENT;
                    DebugLog(@"current node type = %d", currNodeType);
                    break;
                    
                    // node text attribute
                case 2:
                    currNodeText = currAttribute;
                    DebugLog(@"current node text = %@", currNodeText);
                    break;
					
					// node content file name
                case 3:
                    currNodeContentFile = [txtFileDir stringByAppendingPathComponent:currAttribute];
					// all files in Text subdirectory so 
                    DebugLog(@"current node content file = %@", currNodeContentFile);
                    break;
                default:
                    break;
            }
        }
        
		// check for type of node
		if ((currNodeType == ROOT)||(currNodeType == HEADER)) {
            NSLog(@"Create HEADER node %@.", currNodeText);
			currNode = [[[DocumentNode alloc]initWithTextAndType:currNodeText nodeType:currNodeType] autorelease];
		} else if (currNodeType == CONTENT) {
            NSLog(@"Create CONTENT node %@.", currNodeText);
			currNode = [[[DocumentNode alloc]initWithTextTypeContentFile:currNodeText nodeType:currNodeType contentFile:currNodeContentFile] autorelease];

        }
        
		// if last node was same level as current node
        if (currNodeLevel == lastNodeLevel) 
        {
            // add current node to last parent node on stack
            [[parentNodes lastObject] addChildDocumentNode:currNode];
            
        }
        // if current node has higher level than last node,
        // it is child of last node
        else if (currNodeLevel > lastNodeLevel) 
        {
            // add last node to stack of parent nodes 
            [parentNodes addObject:lastNode];
            
            // add current node as child of last node
            [lastNode addChildDocumentNode:currNode];
            
            
        } 
        else if (currNodeLevel < lastNodeLevel)  
        {
            // now have all child nodes for last parent on stack, 
            // it can be remove from stack
            [parentNodes removeLastObject];
            
            // remove all parent nodes until level is current level -1
            int currParentLevel = [parentNodes count] - 1;
            
            // pop parents of stack until currNodeLevel's parent is
            // last on stack
            while (currParentLevel >= currNodeLevel) {
                
                [parentNodes removeLastObject];
                currParentLevel--;
            }
            
            // add current node as child of last node
            DocumentNode *parentNode = [parentNodes lastObject];
            [parentNode addChildDocumentNode:currNode];
            
        }
        
        nodeIndex++;
        lastNode = currNode;
        lastNodeLevel = currNodeLevel;
        currNodeLevel = -1;
		currNodeContentFile = NULL;
		currNodeType = UNDEFINED_NODE_TYPE;
        
    }
    
    currNode = [parentNodes objectAtIndex:0];
    [parentNodes release];
	return currNode;
}	




-(NSString *)readDocumentMapFile
{
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"docmap" 
													 ofType:@"txt"];    
	NSString *rawText = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
													 error:NULL];
	
	return rawText;

}


-(NSArray *)parse:(NSString *)fileContents
{
	
	NSMutableArray *rows = [NSMutableArray array];
	
	// get newline character set
	NSMutableCharacterSet *newlineCharacterSet = (id)[NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
	[newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
	
	// characters that are important to the parser
	NSMutableCharacterSet *importantCharactersSet = (id)[NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
	[importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];
	
	// create scanner, and scan string
	NSScanner *scanner = [NSScanner scannerWithString:fileContents];
	[scanner setCharactersToBeSkipped:nil];
	while ( ![scanner isAtEnd] ) {        
        
		BOOL insideQuotes = NO;
		BOOL finishedRow = NO;
		NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
		NSMutableString *currentColumn = [NSMutableString string];
		while ( !finishedRow ) {
			
			NSString *tempString;
			if ( [scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString] ) {
				[currentColumn appendString:tempString];
			}
			
			if ( [scanner isAtEnd] ) {
				if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
				finishedRow = YES;
			}
			else if ( [scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString] ) {
				if ( insideQuotes ) {
					// Add line break to column text
					[currentColumn appendString:tempString];
				}
				else {
					// End of row
					if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
					finishedRow = YES;
				}
			}
			else if ( [scanner scanString:@"\"" intoString:NULL] ) {
				if ( insideQuotes && [scanner scanString:@"\"" intoString:NULL] ) {
					// Replace double quotes with a single quote in the column string.
					[currentColumn appendString:@"\""]; 
				}
				else {
					// Start or end of a quoted string.
					insideQuotes = !insideQuotes;
				}
			}
			else if ( [scanner scanString:@"," intoString:NULL] ) {  
				if ( insideQuotes ) {
					[currentColumn appendString:@","];
				}
				else {
					// This is a column separating comma
					[columns addObject:currentColumn];
					currentColumn = [NSMutableString string];
					[scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
				}
			}
			
		}
		if ( [columns count] > 0 ) [rows addObject:columns];
	}
	
	return rows;
}


- (void)dealloc {

    [super dealloc];
}



@end
