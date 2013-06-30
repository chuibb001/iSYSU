

#import "CommunicateCell.h"
#import "CommunicateItem.h"

@implementation CommunicateCell

@synthesize characterLabel,  actAndSceneLabel, quotation;

- (void)setQuotation:(CommunicateItem *)newQuotation {

    if(characterLabel == NULL && actAndSceneLabel == NULL){
    characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 123,22)];
    [characterLabel setBackgroundColor:[UIColor clearColor]];
    [characterLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    actAndSceneLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 9, 145, 21)];
    [actAndSceneLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [actAndSceneLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:characterLabel];
    [self addSubview:actAndSceneLabel];
    }
    if (quotation != newQuotation) {
        //quotation = [newQuotation retain];
        quotation = [newQuotation retain];
        characterLabel.text = quotation.numberName;
        actAndSceneLabel.text = quotation.number;
        //quotationTextView.text = quotation.quotation;
    }
}


- (void)dealloc {
    
    [characterLabel release];
    //[quotationTextView release];
    [actAndSceneLabel release];
    [quotation release];
    [super dealloc];   
}

@end

