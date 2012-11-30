//
//  AboutViewController.m
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


#import "AboutViewController.h"
#import "AppManager.h"
#import "Debug.h"



@implementation AboutViewController

#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationItem.title = @"About";
	
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	DebugLog(@" answer is yes");
    // Overriden to allow any orientation.
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	DebugLog(@"received didRotate.");	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are six sections.
    return 2;
}




- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//	NSString *text = [self getSubstanceText:indexPath];
//	
//	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//	
//	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//	
//	CGFloat height = MAX(size.height, 44.0f);
//	
//	return height + (CELL_CONTENT_MARGIN * 2);
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    //returns floating point which will be used for a cell row height at specified row index  
    switch (indexPath.section) {
        case 0:
            return 1700.0; 
        case 1:
            return 300.0;
    }
    
    return 0.0;
    
}  


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"AboutCell";
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // switch on sections and then rows
    switch (indexPath.section) {
        case 0:
            // Configure the cell...
            cell.textLabel.text = @"";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:8];
            cell.detailTextLabel.text = @"These guidelines for the treatment of persons who have or are at risk for sexually transmitted diseases (STDs) were updated by CDC after consultation with a group of professionals knowledgeable in the field of STDs who met in Atlanta on April 18-30, 2009. The information in this report updates the 2006 Guidelines for Treatment of Sexually Transmitted Diseases (MMWR 2006;55[No. RR-11]).\n"
            "\nIncluded in these updated guidelines is new information regarding 1) the expanded diagnostic evaluation for cervicitis and trichomoniasis; 2)new treatment recommendations for bacterial vaginosis and genital warts; 3) the clinical efficacy of azithromycin for chlamydial infections in pregnancy; 4) the role of Mycoplasma genitalium and trichomoniasis in urethritis/cervicitis and treatment-related implications; 5) lymphogranuloma venereum proctocolitis among men who have sex with men; 6) the criteria for spinal fluid examination to evaluate for neurosyphilis; 7) the emergence of azithromycin-resistant Treponema pallidum; 8) the increasing prevalence of antimicrobial-resistant Neisseria gonorrhoeae; 9) the sexual transmission of hepatitis C; 10) diagnostic evaluation after sexual assault; and 11) STD prevention approaches.\n"
            "\nThese guidelines were developed using a multistage process. Beginning in 2008, CDC staff members and public and private sector experts knowledgeable in the field of STDs systematically reviewed literature using an evidence-based approach (e.g., published abstracts and peer-reviewed journal articles), focusing on the common STDs and information that had become available since publication of the 2006 Guidelines for Treatment of Sexually Transmitted Diseases (1). CDC staff members and STD experts developed background papers and tables of evidence that summarized the type of study (e.g., randomized controlled trial or case series), study population and setting, treatments or other interventions, outcome measures assessed, reported findings, and weaknesses and biases in study design and analysis. CDC staff then developed a draft document on the basis of this evidence-based review. In April 2009, this information was presented at a meeting of invited consultants (including public- and private-sector professionals knowledgeable in the treatment of patients with STDs), where all evidence from the literature reviews pertaining to STD management was discussed.\n"
            "\nSpecifically, participants identified key questions regarding STD treatment that emerged from the literature reviews and discussed the information available to answer those questions. Discussion focused on four principal outcomes of STD therapy for each individual disease: 1) treatment of infection based on microbiologic eradication; 2) alleviation of signs and symptoms; 3) prevention of sequelae; and 4) prevention of transmission. Cost-effectiveness and other advantages (e.g., single-dose formulations and directly observed therapy [DOT]) of specific regimens also were discussed. The consultants then assessed whether the questions identified were relevant, ranked them in order of priority, and answered the questions using the available evidence. In addition, the consultants evaluated the quality of evidence supporting the answers on the basis of the number, type, and quality of the studies.\n"
            "\nThe sections on hepatitis B virus (HBV) and hepatitis A virus (HAV) infections are based on previously published recommendations of the Advisory Committee on Immunization Practices (ACIP) (2?4). The recommendations for STD screening during pregnancy and cervical cancer screening were developed after CDC staff reviewed the published recommendations from other professional organizations, including the American College of Obstetricians and Gynecologists (ACOG), United States Preventive Services Task Force (USPSTF), and ACIP.\n"
            "\nThroughout this report, the evidence used as the basis for specific recommendations is discussed briefly. More comprehensive, annotated discussions of such evidence will appear in background papers that will be published in a supplement issue of the journal Clinical Infectious Diseases. When more than one therapeutic regimen is recommended, the sequence is alphabetized unless the choices for therapy are prioritized based on efficacy, convenience, or cost. For those infections with more than one recommended regimen, almost all regimens have similar efficacy and similar rates of intolerance or toxicity unless otherwise specified. Recommended regimens should be used primarily; alternative regimens can be considered in instances of significant drug allergy or other contraindications to the recommended regimens.\n";
            cell.detailTextLabel.numberOfLines = 200;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            // Configure the cell...
            cell.textLabel.text = @"";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:8];
            cell.detailTextLabel.text = @"The mission of the Division of STD Prevention (DSTDP) at the Centers for Disease Control and Prevention is to provide national leadership, research, policy development, and scientific information to help people live safer, healthier lives by the prevention of STDs and their complications. This mission is accomplished by assisting health departments, healthcare providers and non-government organizations (NGO) through the provision of timely science-based information and by clearly interpreting such information to the general public and policy makers. The Division’s specific disease prevention goals are contextualized within the broader framework of the social determinants of health, the promotion of sexual health, and the primary prevention of sexually transmitted disease.\n";
            cell.detailTextLabel.numberOfLines = 60;
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
            title = NSLocalizedString(@"2010 STD Treatment Guidelines", @"");
            break;
        case 1:
            title = NSLocalizedString(@"CDC's Division of STD Prevention", @"");
            break;
        default:
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
