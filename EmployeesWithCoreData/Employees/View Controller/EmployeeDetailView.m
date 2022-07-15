//
//  EmployeeDetailView.m
//  Employees
//
//  Created by Vijaya Madhavi on 20/06/22.
//

#import "EmployeeDetailView.h"
#import "AddEmployeeViewController.h"

@implementation EmployeeDetailView {
    
    __weak IBOutlet UILabel *firstname;
    __weak IBOutlet UILabel *lastname;
    __weak IBOutlet UILabel *role;
    __weak IBOutlet UILabel *email;
    __weak IBOutlet UILabel *phonenumber;
    __weak IBOutlet UILabel *address;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void) customInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"EmployeeDetailView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (void)updateViewWithEmployeeData:(NSManagedObject *)empData {
    
    [firstname setText:[empData valueForKey:@"firstname"]];
    [lastname setText:[empData valueForKey:@"lastname"]];
    [role setText:[empData valueForKey:@"role"]];
    [email setText:[empData valueForKey:@"email"]];
    [phonenumber setText:[empData valueForKey:@"phonenumber"]];
    [address setText:[empData valueForKey:@"address"]];
    
}

@end
