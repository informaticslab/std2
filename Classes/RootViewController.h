//
//  RootViewController.h
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


#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"

@interface RootViewController : UITableViewController <ModalViewDelegate>{

	UITableViewCell *cell0;
    UITableViewCell *cell1;
    UITableViewCell *cell2;

}

@property (nonatomic, retain) IBOutlet UITableViewCell *cell0;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell1;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell2;


- (IBAction)doGuidelines;
- (IBAction)doSearch;
- (IBAction)doTreatments;
- (IBAction)doSymptoms;
- (IBAction)doImageLibrary;
- (IBAction)doGlossary;	
- (IBAction)doReference;
- (IBAction)doAbout;
- (IBAction)doHelp;



@end
