//
//  CoreDataCounterStore.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import CoreData
import CounterCore

public final class CoreDataCounterStore {
    private static let modelName = "CounterStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle.module)
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case persitentContainer(Error)
        case objectNotFound
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataCounterStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(
                name: CoreDataCounterStore.modelName,
                model: model,
                url: storeURL
            )
            context = container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        } catch {
            throw StoreError.persitentContainer(error)
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait {
            result = action(context)
        }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordiantor = self.container.persistentStoreCoordinator
            try? coordiantor.persistentStores.forEach(coordiantor.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

// MARK: - CounterStore Methods

extension CoreDataCounterStore: CounterStore {
    
    public func retrieve() throws -> [Counter] {
        try performSync { context in
            Result {
                try ManagedCounter.all(in: context).map(\.toDomain)
            }
        }
    }
    
    public func insert(_ counters: [Counter]) throws {
        try performSync { context in
            Result {
                _ = ManagedCounter.counters(from: counters, in: context)
                try context.save()
            }
        }
    }
    
    public func counter(with id: Counter.ID) throws -> Counter {
        try performSync { context in
            Result {
                try ManagedCounter.first(with: id, in: context).toDomain
            }
        }
    }
    
    public func delete(with id: Counter.ID) throws {
        try performSync { context in
            Result {
                try ManagedCounter.delete(with: id, in: context)
            }
        }
    }
}
