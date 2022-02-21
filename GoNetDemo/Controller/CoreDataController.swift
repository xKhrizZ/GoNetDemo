//
//  CoreDataController.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 20/02/22.
//

import UIKit
import CoreData
import iOSBusinessDomain
import iOSSecurity

struct CoreDataController {
    
    static let shared = CoreDataController()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: BusinessDomainDB.coreDataModelName)
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Fail to load persistent stores \(error)")
            }
        }
        
        return container
    }()
    
    func addMovie(with id: Int, with data: String) {
        let movie = NSEntityDescription.insertNewObject(forEntityName: BusinessDomainDB.movieEntitieName, into: persistentContainer.viewContext)
        
        let secureData = SecurityManager.base64Encrypt(key: BusinessDomainManager.keyCipher, text: data)
        
        movie.setValue(id, forKey: "id")
        movie.setValue(secureData, forKey: "data")
        
        try? persistentContainer.viewContext.save()
    }
    
    func fetchMovie(with idSection: Int) -> MovieEntitie? {
        let fetchRequest: NSFetchRequest<MovieEntitie> = MovieEntitie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["id",idSection])
        return try? persistentContainer.viewContext.fetch(fetchRequest).first
    }
    
    func fetchMovieCount() -> Int? {
        let fetchRequest: NSFetchRequest<MovieEntitie> = MovieEntitie.fetchRequest()
        return try? persistentContainer.viewContext.fetch(fetchRequest).count
    }
    
    func removeMovie(with idSection: Int) {
        let fetchRequest: NSFetchRequest<MovieEntitie> = MovieEntitie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["id",idSection])
        
        do {
            guard let movie = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            
            persistentContainer.viewContext.delete(movie)
            try? persistentContainer.viewContext.save()
        } catch let error {
            print("Failed to delete move \(error)")
        }
    }
    
    func removeAllRecords() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: BusinessDomainDB.movieEntitieName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        }
        catch
        {
            print ("There was an error")
        }
        
    }
}
