//
//  ViewController.h
//  Employees
//
//  Created by Vijaya Madhavi on 17/06/22.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *employeesTableView;
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

