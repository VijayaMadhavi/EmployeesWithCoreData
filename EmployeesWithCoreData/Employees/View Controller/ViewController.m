//
//  ViewController.m
//  Employees
//
//  Created by Vijaya Madhavi on 17/06/22.
//

#import "ViewController.h"
#import "AddEmployeeViewController.h"
#import "EmployeeSingleton.h"
#import "EmployeeData.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    NSMutableArray *employeesArray;
    NSMutableArray *filteredArray;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    employeesArray = [[EmployeeSingleton getAllEmployeeList] mutableCopy];
    filteredArray = [[NSMutableArray alloc] initWithArray:employeesArray];
    [self.employeesTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;

}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell" forIndexPath:indexPath];
    EmployeeData *employee = [filteredArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",employee.firstname, employee.lastname]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSManagedObjectContext *context = [EmployeeSingleton managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EmployeeData *emp = [filteredArray objectAtIndex:indexPath.row];
        NSManagedObjectID *objectID = [[EmployeeSingleton employeeCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:emp.empId]];
        NSManagedObject *empObj = [EmployeeSingleton empObjectForObjID:objectID];
        
        
        [context deleteObject:empObj];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Cannot delete %@ %@", error, [error localizedDescription]);
            return;
        }

        [filteredArray removeObjectAtIndex:indexPath.row];
        [self.employeesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"edit"]) {
        EmployeeData *employees = [employeesArray objectAtIndex:[[self.employeesTableView indexPathForSelectedRow]row]];
        AddEmployeeViewController *employeeVC = segue.destinationViewController;
        employeeVC.employeesObj = employees;
    }
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    if (searchText.length < 2) {
        filteredArray = employeesArray;
    } else {
        
        NSString *filter = @"%K CONTAINS[cd] %@";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:filter, @"firstname", searchText];
            filteredArray = [employeesArray filteredArrayUsingPredicate:predicate];
    }
    [self.employeesTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = false;
    self.searchBar.text = @"";
    filteredArray = employeesArray;
    [self.employeesTableView reloadData];
    [self.searchBar resignFirstResponder];
}


@end
