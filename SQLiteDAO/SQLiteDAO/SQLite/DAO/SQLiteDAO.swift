//
//  SQLiteDAO.swift
//  SQLiteDAO
//
//  Created by Елена Яновская on 24.02.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import SQLite

open class SQLiteDAO<Model: Entity, SQLiteModel: SQLiteEntry> : DAO<Model> {
    open var translator: SQLiteTranslator<Model, SQLiteModel>
    open var database: Connection!
    
    open let sqliteTable: Table
    open let tableName: String
    open var someEntry: SQLiteModel
    
    public init(_ translator: SQLiteTranslator<Model, SQLiteModel>, configuration: SQLiteConfiguration = SQLiteConfiguration()) {
        self.translator = translator
        tableName = configuration.tableName
        sqliteTable = Table(tableName)
        someEntry = SQLiteModel(table: sqliteTable)
        
        super.init()
        loadDefaultSQLite()
        
        createTable(someEntry.createTable)
    }
    
    open func loadDefaultSQLite() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tableName).appendingPathExtension("sqlite")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    open func createTable(_ createTable: String) {
        if !sqliteTable.exists.asSQL().hasPrefix("SELECT EXISTS") {
            do {
                try self.database.run(createTable)
            } catch {
                print(error)
            }
        }
    }
    
    open func persist(_ entity: Model) {
        let inserts = translator.fill(someEntry, table: sqliteTable, fromEntity: entity)
        do {
            try self.database.run(inserts)
        } catch {
            print(error)
        }
    }
    
    open func persist(_ entities: [Model]) {
        for entity in entities {
            persist(entity)
        }
    }
    
    open func deleteAll () {
        let user = self.sqliteTable
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
    
    open func readAll() -> [Model] {
        var entries = [SQLiteModel]()
        
        do {
            let tableInfo = try database.prepare("PRAGMA table_info(\(tableName))")
            var columns = [Expression<String>]()
            for line in tableInfo {
                columns.append(Expression<String>(line[1] as! String))
            }
            
            let rows = try self.database.prepare(self.sqliteTable)
            for row in rows {
                var entryArray = [String]()
                for column in columns {
                    entryArray.append(row[column])
                }
                var entry = SQLiteModel()
                entry.arrayOfItems = entryArray
                entries.append(entry)
            }
        } catch {
            print(error)
        }
        
        let models = translator.fill(fromEntries: entries)
        return models
    }
}
