//
//  AddEmployeeViewController.h
//  Employees
//
//  Created by Vijaya Madhavi on 17/06/22.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "EmployeeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddEmployeeViewController : UIViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *employeeImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *roleTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong) EmployeeData *employeesObj;

- (IBAction)saveButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
