//
//  Document.m
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


#import "Document.h"
#import "DocumentMap.h"

@implementation Document

@synthesize rootNode, allNodes, docMap;

-(id)init
{
    if ((self = [super init]))
    {
		self.docMap = [[DocumentMap alloc] init];
		self.rootNode = self.docMap.rootNode;

    }

    return self;
    
}

-(id)initWithTitle:(NSString *)newTitle
{
    if (self = [super init])
    {
        self.rootNode = [[DocumentNode alloc ]initWithTextAndType:newTitle nodeType:ROOT]; 
        
    }
    
    return self;
}

-(void)loadTestData
{
	
    DocumentNode *n1, *n2, *n3;
    self.rootNode = [[DocumentNode alloc] initWithTextAndType:@"STD Guidelines" nodeType:ROOT];
    
    n1 = [[DocumentNode alloc] initWithTextAndType:@"Clinical Prevention of STDs" nodeType:HEADER];
    n2 = [[DocumentNode alloc] initWithTextTypeContentFile:@"Overview" nodeType:CONTENT contentFile:@"overview"];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];

    n2 = [[DocumentNode alloc] initWithTextTypeContentFile:@"STD-HIV" nodeType:CONTENT contentFile:@"std-hiv"];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];

    n2 = [[DocumentNode alloc] initWithTextAndType:@"Prevention Methods" nodeType:HEADER];
    n3 = [[DocumentNode alloc] initWithTextTypeContentFile:@"Prevention Methods" nodeType:CONTENT contentFile:@"prevention"];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Abstinence and Reduction of Number of Sex Partners" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Preexposure Vaccination" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Male Condoms" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Female Condoms" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Vaginal Spermicides and Diaphragms" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Condoms and N-9 Vaginal Spermicides" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Rectal Use of N-9 Spermicides" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Nonbarrier Contraception, Surgical Sterilization, and Hysterectomy" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Emergency Contraception" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	n3 = [[DocumentNode alloc] initWithTextAndType:@"Postexposure Prophylaxis (PEP) for HIV" nodeType:HEADER];
	[n2 addChildDocumentNode:n3]; 
    [n3 release];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];
    
	n2 = [[DocumentNode alloc] initWithTextTypeContentFile:@"Partner Management" nodeType:CONTENT contentFile:@"partners"];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];

    n2 = [[DocumentNode alloc] initWithTextTypeContentFile:@"Reporting/Confidentiality" nodeType:CONTENT contentFile:@"reporting"];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];

    n2 = [[DocumentNode alloc] initWithTextTypeContentFile:@"Vaccine Preventable STDs" nodeType:CONTENT contentFile:@"vaccine"];
	[n1 addChildDocumentNode:n2]; 
    [n2 release];
	[self.rootNode addChildDocumentNode:n1];
    [n1 release];
	
    n1 = [[DocumentNode alloc] initWithTextAndType:@"By Populations/Situations" nodeType:HEADER];
	[self.rootNode addChildDocumentNode:n1]; 
    [n1 release];
	
    n1 = [[DocumentNode alloc] initWithTextAndType:@"By Specific Disease" nodeType:HEADER];
	[self.rootNode addChildDocumentNode:n1]; 
    [n1 release];
	
    n1 = [[DocumentNode alloc] initWithTextAndType:@"By Clinical Condition" nodeType:HEADER];
	[self.rootNode addChildDocumentNode:n1]; 
    [n1 release];
	
    [self.rootNode printChildNodes];

}


-(void)createArrayOfNodes
{
	
	NSMutableArray *nodes = [[NSMutableArray alloc] init];
	
	// first add root, then walk all nodes and add child nodes
	[self.rootNode addChildNodesToArray:nodes];
	
	self.allNodes = [[NSArray alloc] initWithArray:nodes];
	
	[nodes release];
	
}

-(void)searchForText:(SearchContext *)context
{
    
    [self.rootNode searchForText:context];
    
}

-(void)testSearch
{
	
	SearchContext *testContext = [[SearchContext alloc] init];
	testContext.searchString = @"Spermicides";
	
	[self searchForText:testContext];

	
}

- (void)dealloc 
{
	[self.docMap release];
	[super dealloc];
}


@end
