//
//  EmployeeData.h
//  Employees
//
//  Created by Vijaya Madhavi on 07/07/22.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmployeeData : NSManagedObject

@property (nonatomic, retain) NSString *empId;
@property (nonatomic, strong) UIImage *empimage;
@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phonenumber;
@property (nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
