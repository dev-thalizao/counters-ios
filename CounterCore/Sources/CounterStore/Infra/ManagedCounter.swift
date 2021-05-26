//
//  ManagedCounter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import CoreData
import CounterCore

@objc(ManagedCounter)
final class ManagedCounter: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var count: Int16
}

extension ManagedCounter {
    
    static func all(in context: NSManagedObjectContext) throws -> [ManagedCounter] {
        let request = NSFetchRequest<ManagedCounter>(entityName: "ManagedCounter")
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func counters(from counters: [Counter], in context: NSManagedObjectContext) -> [ManagedCounter]  {
        return counters.map { counter in
            let managed = ManagedCounter(context: context)
            managed.id = counter.id
            managed.title = counter.title
            managed.count = Int16(counter.count)
            return managed
        }
    }
    
    static func first(with id: Counter.ID, in context: NSManagedObjectContext) throws -> ManagedCounter {
        let request = NSFetchRequest<ManagedCounter>(entityName: "ManagedCounter")
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedCounter.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        guard let counter = try context.fetch(request).first else {
            throw CoreDataCounterStore.StoreError.modelNotFound
        }
        
        return counter
    }
    
    static func delete(with id: Counter.ID, in context: NSManagedObjectContext) throws {
        let managed = try first(with: id, in: context)
        context.delete(managed)
        try context.save()
    }
    
    var toDomain: Counter {
        return Counter(id: id, title: title, count: Int(count))
    }
}
