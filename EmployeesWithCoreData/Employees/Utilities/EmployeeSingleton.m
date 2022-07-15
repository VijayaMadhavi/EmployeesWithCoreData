//
//  EmployeeSingleton.m
//  Employees
//
//  Created by Vijaya Madhavi on 05/07/22.
//

#import "EmployeeSingleton.h"
#import "EmployeeData.h"

@implementation EmployeeSingleton

+ (NSPersistentContainer *)persistentContainer {
    
    static NSPersistentContainer *persistentContainer;
    
    @synchronized (self) {
        if (persistentContainer == nil) {
            persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Employees"];
            [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                   
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }

    return persistentContainer;
}

+ (NSPersistentStoreCoordinator *)employeeCoordinator {
    
    static NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    persistentStoreCoordinator = [EmployeeSingleton generatePersistentStoreWithModel:[EmployeeSingleton managedObjectModel] andDatabaseName:@"/Employees.sqlite"];
    return persistentStoreCoordinator;
}

+ (NSPersistentStoreCoordinator *)generatePersistentStoreWithModel:(NSManagedObjectModel *)model andDatabaseName:(NSString *)dbName {
    NSError *error = nil;

    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES,
                              NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}};

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSURL *url = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingString:dbName]];

    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error]) {
      //  [self printError:error];
        error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[url path] error:&error];
        if (error) {
           // [self printError:error];
        }
        return [self generatePersistentStoreWithModel:model andDatabaseName:dbName];
    }
    return persistentStoreCoordinator;
}

+ (NSManagedObjectContext *)managedObjectContext {
    
    static NSManagedObjectContext *managedObjectContext;
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    } else {
        NSPersistentStoreCoordinator *coordinator = [self employeeCoordinator];
        if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return managedObjectContext;
}

+ (NSManagedObjectModel *) managedObjectModel {
    
    static NSManagedObjectModel *managedObjectModel;
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:@"Employees" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

+ (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) lastObject];
}

+ (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

+ (NSArray *)getAllEmployeeList {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Employee"];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES]]];
    NSArray *empArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *emp in empArray) {
        EmployeeData *employee = [[EmployeeData alloc] init];
        employee.empId =[[[emp objectID] URIRepresentation] absoluteString];
        employee.empimage = [UIImage imageWithData:[emp valueForKey:@"empimage"]];
        employee.firstname = [emp valueForKey:@"firstname"];
        employee.lastname = [emp valueForKey:@"lastname"];
        employee.role = [emp valueForKey:@"role"];
        employee.email = [emp valueForKey:@"email"];
        employee.phonenumber = [emp valueForKey:@"phonenumber"];
        employee.address = [emp valueForKey:@"address"];
        
        [arrayTemp addObject:employee];
    }
    return arrayTemp;
    
}

+ (NSManagedObject *)empObjectForObjID:(NSManagedObjectID *)objectID {
    __block NSManagedObject *obj = nil;
    [[EmployeeSingleton managedObjectContext] performBlockAndWait:^{
        obj = [[EmployeeSingleton managedObjectContext] objectWithID:objectID];
    }];
    return obj;
}

+ (void) saveOrUpdateEmployeeDataToDB:(EmployeeData *)emp {

        NSManagedObjectContext *context = [EmployeeSingleton managedObjectContext];
           if (emp.empId) {
            
               NSManagedObjectID *objectID = [[EmployeeSingleton employeeCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:emp.empId]];
               NSManagedObject *empObj = [EmployeeSingleton empObjectForObjID:objectID];
               
              NSData *imageData = UIImageJPEGRepresentation(emp.empimage, 1.0);
       
               [empObj setValue:imageData forKey:@"empimage"];
               [empObj setValue:emp.firstname forKey:@"firstname"];
               [empObj setValue:emp.lastname forKey:@"lastname"];
               [empObj setValue:emp.role forKey:@"role"];
               [empObj setValue:emp.email forKey:@"email"];
               [empObj setValue:emp.phonenumber forKey:@"phonenumber"];
               [empObj setValue:emp.address forKey:@"address"];
       
           } else {
               NSManagedObject *newEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
               
              NSData *imageData = UIImageJPEGRepresentation(emp.empimage, 1.0);
       
               [newEmployee setValue:imageData forKey:@"empimage"];
               [newEmployee setValue:emp.firstname forKey:@"firstname"];
               [newEmployee setValue:emp.lastname forKey:@"lastname"];
               [newEmployee setValue:emp.role forKey:@"role"];
               [newEmployee setValue:emp.email forKey:@"email"];
               [newEmployee setValue:emp.phonenumber forKey:@"phonenumber"];
               [newEmployee setValue:emp.address forKey:@"address"];
       
           }
           NSError *error = nil;
           if (![context save:&error]) {
               NSLog(@"Cannot save the data %@ %@", error, [error localizedDescription]);
           }
    
}

@end
