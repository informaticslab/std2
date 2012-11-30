//
//  HelpViewController.m
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


#import "HelpViewController.h"
#import "AppManager.h"
#import "Debug.h"

@implementation HelpViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Help";
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    //returns floating point which will be used for a cell row height at specified row index  
    switch (indexPath.section) {
        case 0:
            return 200.0; 
    }
    
    return 0.0;
    
}  



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"HelpCell";
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier] autorelease];
		
    }
    
    // switch on sections and then rows
    switch (indexPath.section) {
        case 0:
            // Configure the cell...
            cell.textLabel.text = @"";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:8];
            cell.detailTextLabel.text = @"If you have any questions, please contact the CDC:\n"
            "\n    Centers for Disease Control and Prevention"
            "\n    1600 Clifton Rd"
            "\n    Atlanta, GA 30333"
            "\n\n    800-CDC-INFO"
            "\n    (800-232-4636)"
            "\n    TTY: (888) 232-6348"
            "\n    24 Hours/Every Day"
            "\n\n    cdcinfo@cdc.gov";
            
            cell.detailTextLabel.numberOfLines = 20;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
            
    }
    
    
	// Set the text in the cell for the section/row.
    return cell;
}


#pragma mark -
#pragma mark Section header titles

/*
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Help", @"");
            break;
    }
    return title;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
