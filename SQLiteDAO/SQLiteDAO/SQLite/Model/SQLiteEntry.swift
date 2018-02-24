//
//  SQLiteEntry.swift
//  SQLiteDAO
//
//  Created by Елена Яновская on 24.02.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import SQLite

public protocol SQLiteEntry {
    
    var arrayOfItems: [String]! { get set }
    var createTable: String! { get set }
    
    init()
    init(table: Table)
}
