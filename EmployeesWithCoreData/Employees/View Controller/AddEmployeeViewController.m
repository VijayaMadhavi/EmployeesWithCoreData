//
//  AddEmployeeViewController.m
//  Employees
//
//  Created by Vijaya Madhavi on 17/06/22.
//

#import "AddEmployeeViewController.h"
#import "EmployeeDetailView.h"
#import "EmployeeSingleton.h"

@interface AddEmployeeViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation AddEmployeeViewController {
    
    UIPickerView *rolePickerView;
    NSArray *roleArray;
    EmployeeDetailView *employeeView;
    
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet NSLayoutConstraint *saveTopConstraint;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.employeesObj) {
        [self loadEmployeeData];
    }
    
    [self gestureRecognizers];
    
    [self setupPickers];
    
    
}

#pragma mark - Gesture Recognizers and their methods

- (void) gestureRecognizers {
    
   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.employeeImageView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Select an action" message:@"Choose an action for displaying an image" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Select an image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } 
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}

- (void) swipeAction:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
       [self.navigationController popViewControllerAnimated:YES];
        }
}

#pragma mark - PickerView and ImagePickerController setup

- (void) setupPickers {
    
    rolePickerView = [[UIPickerView alloc] init];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    rolePickerView.delegate = self;
    
    roleArray = [NSArray arrayWithObjects:@"iOS Developer", @"Android Developer", @".Net Developer", @"Java Developer", @"FullStack Developer", nil];
    self.roleTextField.inputView = rolePickerView;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,400,40)];
    [toolBar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor = [UIColor blackColor];
    self.roleTextField.inputAccessoryView = toolBar;
    
}

- (void) doneTapped: (id)sender {
    [self.roleTextField resignFirstResponder];
}

#pragma mark - Loading Employee details into ViewController

- (void) loadEmployeeData {

    [self.employeeImageView setImage:self.employeesObj.empimage];
    [self.firstnameTextField setText:self.employeesObj.firstname];
    [self.lastnameTextField setText:self.employeesObj.lastname];
    [self.roleTextField setText:self.employeesObj.role];
    [self.emailTextField setText:self.employeesObj.email];
    [self.phonenumberTextField setText:self.employeesObj.phonenumber];
    [self.addressTextView setText:self.employeesObj.address];

}

- (BOOL)validateTextFields {
    if(_firstnameTextField.text.length > 0 && _lastnameTextField.text.length > 0 && _roleTextField.text.length > 0 && _emailTextField.text.length > 0 && _phonenumberTextField.text.length > 0 && _addressTextView.text.length > 0) {
        if(_phonenumberTextField.text.length < 10 || _phonenumberTextField.text.length > 10) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter valid number" message:@"Phone number should be 10 digits" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }
        return YES;
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter something." message:@"Please type something in all the fields." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
}

- (IBAction)saveButton:(id)sender {
    if([self validateTextFields]) {
        if(!self.employeesObj) {
            self.employeesObj = [[EmployeeData alloc] init];
        }
        self.employeesObj.firstname = _firstnameTextField.text;
        self.employeesObj.lastname = _lastnameTextField.text;
        self.employeesObj.role = _roleTextField.text;
        self.employeesObj.email = _emailTextField.text;
        self.employeesObj.address = _addressTextView.text;
        self.employeesObj.phonenumber = _phonenumberTextField.text;
        self.employeesObj.empimage = _employeeImageView.image;
        [EmployeeSingleton saveOrUpdateEmployeeDataToDB:self.employeesObj];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    self.employeeImageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    return roleArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return roleArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.roleTextField.text = roleArray[row];
    
}

@end
