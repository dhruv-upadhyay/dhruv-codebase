//
//  Database.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import CoreData

class Database {
    // Singleton instance of the Database class
    static let shared = Database()
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    /// Saves a new record of type `T` into CoreData.
    ///
    /// - Parameters:
    ///   - entityName: The name of the entity to save.
    ///   - attributes: A dictionary of attribute names and values to set for the new record.
    ///   - context: The NSManagedObjectContext where the record will be saved.
    ///   - completion: A completion handler returning a Result with the saved object of type `T` or an error.
    func saveRecord<T: NSManagedObject>(_ entityName: String, attributes: [String: Any], context: NSManagedObjectContext, completion: @escaping (Result<T, Error>) -> Void) {
        // Perform the CoreData operation asynchronously on the provided context
        context.perform {
            do {
                // Ensure the entity exists in the given context
                guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                    throw NSError(domain: "EntityNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])
                }
                
                // Create a new object of type `T` and set its attributes
                let newObject = T(entity: entity, insertInto: context)
                newObject.setValuesForKeys(attributes)
                
                // Save the context after setting values
                try context.save()
                
                // Completion handler returns the newly saved object or an error
                completion(.success(newObject))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Updates an existing record of type `T` in CoreData with new attributes.
    ///
    /// - Parameters:
    ///   - object: The object of type `T` to update.
    ///   - attributes: A dictionary of attribute names and new values to set for the object.
    ///   - context: The NSManagedObjectContext where the update will be performed.
    ///   - completion: A completion handler returning a Result with the updated object of type `T` or an error.
    func updateRecord<T: NSManagedObject>(_ object: T, with attributes: [String: Any], context: NSManagedObjectContext, completion: @escaping (Result<T, Error>) -> Void) {
        // Perform the CoreData operation asynchronously on the provided context
        context.perform {
            do {
                // Set new values for the existing object
                object.setValuesForKeys(attributes)
                
                // Save the context after updating values
                try context.save()
                
                // Completion handler returns the updated object or an error
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Deletes an existing record of type `T` from CoreData.
    ///
    /// - Parameters:
    ///   - object: The object of type `T` to delete.
    ///   - context: The NSManagedObjectContext where the deletion will be performed.
    ///   - completion: A completion handler returning a Result indicating success or failure.
    func deleteRecord<T: NSManagedObject>(_ object: T, context: NSManagedObjectContext, completion: @escaping (Result<Void, Error>) -> Void) {
        // Perform the CoreData operation asynchronously on the provided context
        context.perform {
            do {
                // Delete the object from the context
                context.delete(object)
                
                // Save the context after deletion
                try context.save()
                
                // Completion handler indicates success
                completion(.success(()))
            } catch {
                // Completion handler returns error if deletion fails
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches records of type `T` from CoreData based on optional predicates and sort descriptors.
    ///
    /// - Parameters:
    ///   - entityName: The name of the entity to fetch records from.
    ///   - predicate: An optional NSPredicate to filter fetched records.
    ///   - sortDescriptors: Optional array of NSSortDescriptor objects to sort fetched records.
    ///   - context: The NSManagedObjectContext where the fetch request will be performed.
    ///   - completion: A completion handler returning a Result with an array of fetched objects of type `T` or an error.
    func fetchRecords<T: NSManagedObject>(_ entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext, completion: @escaping (Result<[T], Error>) -> Void) {
        // Perform the CoreData operation asynchronously on the provided context
        context.perform {
            // Create a fetch request for the specified entity
            let fetchRequest = NSFetchRequest<T>(entityName: entityName)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            do {
                // Fetch objects matching the criteria
                let fetchedObjects = try context.fetch(fetchRequest)
                
                // Completion handler returns the fetched objects or an error
                completion(.success(fetchedObjects))
            } catch {
                // Completion handler returns error if fetching fails
                completion(.failure(error))
            }
        }
    }
}

