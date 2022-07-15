//
//  EmployeeDetails.h
//  Employees
//
//  Created by Vijaya Madhavi on 20/06/22.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmployeeDetailView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)updateViewWithEmployeeData:(NSManagedObject *)empData;

@end

NS_ASSUME_NONNULL_END
