//
//  EmployeeSingleton.h
//  Employees
//
//  Created by Vijaya Madhavi on 05/07/22.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "EmployeeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmployeeSingleton : NSObject

+ (void)saveContext;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSString *)applicationDocumentsDirectory;
+ (NSArray *)getAllEmployeeList;
+ (void) saveOrUpdateEmployeeDataToDB:(EmployeeData *)emp;
+ (NSManagedObject *)empObjectForObjID:(NSManagedObjectID *)objectID;
+ (NSPersistentStoreCoordinator *)employeeCoordinator;

@end

NS_ASSUME_NONNULL_END
