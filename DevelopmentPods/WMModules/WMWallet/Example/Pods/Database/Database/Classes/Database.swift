//
//  Database.swift
//  Boostcode
//
//  Created by Matteo Crippa on 3/20/17.
//  Copyright © 2017 Boostco.de. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import SwiftyJSONRealmObject

public enum DatabaseDebugVerbosity {
  case none
  case all
  case error
  case message
}

public enum DatabaseWriteType: String {
  case memory = "inMemory"
  case disk = "onDisk"
}

/// Database configuration struct
open class DatabaseConfiguration{
  var name = ""
  var type: DatabaseWriteType = .disk
  var debug: DatabaseDebugVerbosity = .none
  
  public init(name: String = "", type: DatabaseWriteType = .disk, debug: DatabaseDebugVerbosity = .none) {
    self.name = name
    self.type = type
    self.debug = debug
  }
}

fileprivate protocol Databaseable: class {
  static var shared: Database { get }

  var database: Realm? { get }
  var configuration: DatabaseConfiguration? { get }

  func configure(configuration: DatabaseConfiguration)

  func get<T>(type: T.Type) -> Results<T>?
  func get<T: Object, K>(type: T.Type, key: K) -> T?

  func save<T>(type: T.Type, json: JSON, deleteAll: Bool, isSingle: Bool) where T: SwiftyJSONRealmObject
  func save(object: Object)
  func save<S: Sequence>(objects: S) where S.Iterator.Element: Object

  func delete(object: Object)
}

fileprivate extension Databaseable {
  func connectDb(name: String, type: DatabaseWriteType = .disk, debug: Bool = false) {}
  func save<T>(type: T.Type, json: JSON, deleteAll: Bool = false, isSingle: Bool = false) where T: SwiftyJSONRealmObject {}
}

open class Database: Databaseable {

  /// Shared instance
  open static var shared = Database()
  private init() {}

  /// Database handler
  open var database: Realm?

  /// Database configuration
  var configuration: DatabaseConfiguration?

  open func configure(configuration: DatabaseConfiguration) {

    // set debug status
    self.configuration = configuration

    // create conf file
    var dbConf = Realm.Configuration()

    switch configuration.type {
    case .memory:
      dbConf.fileURL = nil
      dbConf.inMemoryIdentifier = configuration.type.rawValue
    case .disk:
      break
    }

    // we want full RW
    dbConf.readOnly = false

    // force schema to 0
    dbConf.schemaVersion = 0

    // setup database
    do {
      database = try Realm(configuration: dbConf)
    } catch (let e) {
      debug(error: e.localizedDescription)
    }

    // show info for database if verbose
    settings(data: "🔌 Database Setup")
    settings(data: dbConf.description)
    settings(data: "🗺 Path to realm file: " + (database?.configuration.fileURL!.absoluteString)!)
  }

  /// Get an object of type for key
  ///
  /// - Parameters:
  ///   - type: object type
  ///   - key: key to filter items
  /// - Returns: return an object
  open func get<T: Object, K>(type: T.Type, key: K) -> T? {

    guard let database = database else {
      debug(error: "instance not available")
      return nil
    }

    return database.object(ofType: type, forPrimaryKey: key)
  }

  /// Get all object of type
  ///
  /// - Parameter type: type of object
  /// - Returns: return a result list of type
  open func get<T>(type: T.Type) -> Results<T>? {

    guard let database = database else {
      debug(error: "instance not available")
      return nil
    }

    return database.objects(type)
  }

  /// Save a sequence of object in database
  ///
  /// - Parameter objects: objects to be saved
  open func save<S: Sequence>(objects: S) where S.Iterator.Element: Object {
    /// Get the current database instance
    guard let database = database else {
      debug(error: "instance not available")
      return
    }

    do {
      try database.write {
        debug(data: Array(objects).description)
        database.add(objects, update: true)
      }
    } catch(let e) {
      debug(error: e.localizedDescription)
    }
  }

  /// Save an object in database
  ///
  /// - Parameter object: object item
  open func save(object: Object) {

    /// Get the current database instance
    guard let database = database else {
      debug(error: "instance not available")
      return
    }

    do {
      try database.write {
        debug(data: object.description)
        database.add(object, update: true)
      }
    } catch(let e) {
      debug(error: e.localizedDescription)
    }
  }

  /// Save json objects in database
  ///
  /// - Parameters:
  ///   - type: data model type
  ///   - json: json content
  ///   - deleteAll: if we want to delete all the items before
  ///   - isSingle: if we have to add only an item
  open func save<T>(type: T.Type, json: JSON, deleteAll: Bool = false, isSingle: Bool = false) where T: SwiftyJSONRealmObject {

    /// Get the current database instance
    guard let database = database else {
      debug(error: "instance not available")
      return
    }

    do {
      try database.write {
        // removes all the entries of T type
        if deleteAll {
          database.delete(database.objects(T.self))
        }

        debug(data: json.description)

        // check if we have to add only an item
        if isSingle {
          database.add(T(json: json), update: true)
        } else {
          database.add(SwiftyJSONRealmObject.createList(ofType: T.self, fromJson: json), update: true)
        }
      }
    } catch (let e) {
      debug(error: e.localizedDescription)
    }
  }

  /// Delete objects from realm
  ///
  /// - Parameter object: Object of realm type
  open func delete(object: Object) {

    /// Get the current database instance
    guard let database = database else {
      debug(error: "instance not available")
      return
    }

    do {
      try database.write {
        debug(data: object.description)
        database.delete(object)
      }
    } catch(let e) {
      debug(error: e.localizedDescription)
    }
  }

  /// Error debug log wrapper for db
  ///
  /// - Parameter error: string error
  fileprivate func debug(error: String) {
    if let configuration = configuration {
      if configuration.debug == .all || configuration.debug == .error {
        print("🗄❌ Database Error ❌ > " + error)
      }
    }
  }

  /// Action debug log wrapper for db
  ///
  /// - Parameter data: string
  fileprivate func debug(data: String) {
    if let configuration = configuration {
      if configuration.debug == .all || configuration.debug == .message {
        print("🗄👉 Database > " + data)
      }
    }
  }

  /// Action settings log wrapper for db
  ///
  /// - Parameter data: string
  fileprivate func settings(data: String) {
    if let configuration = configuration {
      if configuration.debug == .all || configuration.debug == .message || configuration.debug == .error {
        print("🗄🎚 Database > " + data)
      }
    }
  }

}
