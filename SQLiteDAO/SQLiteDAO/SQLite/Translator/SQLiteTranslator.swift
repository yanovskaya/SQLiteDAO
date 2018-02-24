//
//  SQLiteTranslator.swift
//  SQLiteDAO
//
//  Created by Елена Яновская on 24.02.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import SQLite

open class SQLiteTranslator<Model: Entity, SQLiteModel: SQLiteEntry> {
    
    open func fill(fromEntry: SQLiteModel) -> Model {
        fatalError("Abstract method")
    }
    
    open func fill(_ entry: SQLiteModel, table: Table, fromEntity: Model) -> Insert {
        fatalError("Abstract method")
    }
    
    open func fill(fromEntries: [SQLiteModel]) -> [Model] {
        var models = [Model]()
        for entry in fromEntries {
            models.append(fill(fromEntry: entry))
        }
        return models
    }
}
