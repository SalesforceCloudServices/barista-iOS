//
//  Record.swift
//  Test
//
//  Created by David Vieser on 9/27/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import Foundation
import SmartStore

protocol StoreProtocol {
    init()
    init(data: [Any])
    var data: Dictionary<String,Any> {get}
    static var objectName: String {get}
    var objectType: String? {get set}
    var local: Bool {get set}
    var locallyCreated: Bool {get set}
    var locallyUpdated: Bool {get set}
    var locallyDeleted: Bool {get set}
    var soupEntryId: Int? {get}
    static var indexes: [[String:String]] {get}
    static var orderPath: String {get}
    static var readFields: [String] {get}
    static var createFields: [String] {get}
    static var updateFields: [String] {get}
    static func from<T:StoreProtocol>(_ records: [Any]) -> T
    static func from<T:StoreProtocol>(_ records: [Any]) -> [T]
    static func from<T:StoreProtocol>(_ records: Dictionary<String, Any>) -> T
}

class Record {
    required init(data: [Any]) {
        self.data = (data as! [Dictionary]).first!
    }

    required init() {
        self.externalId = UUID().uuidString
    }
    
    var data: Dictionary = Dictionary<String,Any>()

    enum Field: String {
        case id = "Id"
        case externalId = "MobileExternalId__c"
        case soupEntryId = "_soupEntryId"
        case soupLastModifiedDate = "_soupLastModifiedDate"
        case soupCreatedDate = "_soupCreatedDate"
        case local = "__local__"
        case locallyCreated = "__locally_created__"
        case locallyUpdated = "__locally_updated__"
        case locallyDeleted = "__locally_deleted__"
        case modificationDate = "LastModifiedDate"
        case attributes = "attributes"
        case objectType = "type"
        
        fileprivate static let allFields = [id.rawValue, modificationDate.rawValue, externalId.rawValue]
    }

    var externalId: String? {
        get { return self.data[Field.externalId.rawValue] as? String }
        set { data[Field.externalId.rawValue] = newValue }
    }
    private(set) lazy var soupEntryId: Int? = self.data[Field.soupEntryId.rawValue] as? Int
    private(set) lazy var id: String? = self.data[Field.id.rawValue] as? String
    var objectType: String? {
        get { return (data[Field.attributes.rawValue] as! Dictionary<String, Any>)[Field.objectType.rawValue] as? String }
        set {
            if var attributes = data[Field.attributes.rawValue] as? Dictionary<String, String> {
                attributes[Field.objectType.rawValue] = newValue
            } else {
                data[Field.attributes.rawValue] = [Field.objectType.rawValue : newValue]
            }
        }
    }
    var local: Bool {
        get { return (data[Field.local.rawValue] as! String) == "1" }
        set { data[Field.local.rawValue] = newValue ? "1" : "0" }
    }
    var locallyCreated: Bool {
        get { return (data[Field.locallyCreated.rawValue] as! String) == "1" }
        set {
            data[Field.locallyCreated.rawValue] = newValue ? "1" : "0"
            data[Field.local.rawValue] = newValue ? "1" : "0"
        }
    }
    var locallyUpdated: Bool {
        get { return (data[Field.locallyUpdated.rawValue] as! String) == "1" }
        set {
            data[Field.locallyUpdated.rawValue] = newValue ? "1" : "0"
            data[Field.local.rawValue] = newValue ? "1" : "0"
        }

    }
    var locallyDeleted: Bool {
        get { return (data[Field.locallyDeleted.rawValue] as! String) == "1" }
        set {
            data[Field.locallyDeleted.rawValue] = newValue ? "1" : "0"
            data[Field.local.rawValue] = newValue ? "1" : "0"
        }

    }
    class var indexes: [[String:String]] {
         return [["path" : Field.id.rawValue, "type" : kSoupIndexTypeString],
                 ["path" : Field.modificationDate.rawValue, "type" : kSoupIndexTypeInteger],
                 ["path" : Field.externalId.rawValue, "type" : kSoupIndexTypeString],
                 ["path" : Field.soupEntryId.rawValue, "type" : kSoupIndexTypeString],
                 ["path" : Field.local.rawValue, "type" : kSoupIndexTypeInteger],
                 ["path" : Field.locallyCreated.rawValue, "type" : kSoupIndexTypeInteger],
                 ["path" : Field.locallyUpdated.rawValue, "type" : kSoupIndexTypeInteger],
                 ["path" : Field.locallyDeleted.rawValue, "type" : kSoupIndexTypeInteger],
        ]
    }
    class var readFields: [String] {
        return Field.allFields + [Field.soupEntryId.rawValue]
    }
    class var createFields: [String] {
        return Field.allFields
    }
    class var updateFields: [String] {
        return []
    }
}

extension StoreProtocol {
    func description() -> String {
        return "\(type(of: self).objectName)"
    }

    static func from<T:StoreProtocol>(_ records: [Any]) -> T {
        var resultsDictionary = Dictionary<String, Any>()
        if let results = records.first as? [Any] {
            zip(T.readFields, results).forEach { resultsDictionary[$0.0] = $0.1 }
        } else if let results = records.first as? Dictionary<String, Any> {
            return T.from(results)
        }
        return T(data: [resultsDictionary])
    }
    
    static func from<T:StoreProtocol>(_ records: Dictionary<String, Any>) -> T {
        return T(data: [records])
    }
    
    static func from<T:StoreProtocol>(_ records: [Any]) -> [T] {
        return records.map {
            if let record = $0 as? Dictionary<String, Any> {
                return T.from(record)
            } else if let record = $0 as? [Any] {
                var resultsDictionary = Dictionary<String, Any>()
                zip(T.readFields, record).forEach { resultsDictionary[$0.0] = $0.1 }
                return T.from(resultsDictionary)
            } else {
                return T()
            }
//            return T.from($0 as! Dictionary<String, Any>)
            
        }
    }
    
    static func selectFieldsString() -> String {
        return readFields.map { return "{\(objectName):\($0)}" }.joined(separator: ", ")
    }
}
