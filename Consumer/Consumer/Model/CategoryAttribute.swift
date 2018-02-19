//
//  Product.swift
//  Consumer
//
//  Created by David Vieser on 1/30/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import SmartStore

enum CategoryAttributeType: String {
    case slider = "Slider"
    case picklist = "Picklist"
    case multiselect = "Multiselect"
    case integer = "Integer"
}

class CategoryAttribute: Record, StoreProtocol {
    static let objectName: String = "CategoryAttribute__c"
    
    enum Field: String {
        case name = "Name"
        case categoryId = "Category__c"
        case iconImageURL = "IconImageURL__c"
        case attributeType = "AttributeType__c"
        case sortOrder = "SortOrder__c"

        static let allFields = [name.rawValue, categoryId.rawValue, iconImageURL.rawValue, attributeType.rawValue, sortOrder.rawValue]
    }
    
    fileprivate(set) lazy var name: String? = data[Field.name.rawValue] as? String
    fileprivate(set) lazy var catgoryId: String? = data[Field.categoryId.rawValue] as? String
    fileprivate(set) lazy var iconImageURL: String? = data[Field.iconImageURL.rawValue] as? String
    fileprivate(set) lazy var attributeType: CategoryAttributeType? = CategoryAttributeType(rawValue: data[Field.attributeType.rawValue] as! String)
    fileprivate(set) lazy var sortOrder: String? = data[Field.sortOrder.rawValue] as? String

    override static var indexes: [[String : String]] {
        return super.indexes + [
            ["path" : Field.name.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.categoryId.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.iconImageURL.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.attributeType.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.sortOrder.rawValue, "type" : kSoupIndexTypeString],
        ]
    }
    
    override static var readFields: [String] {
        return super.readFields + Field.allFields
    }
    override static var createFields: [String] {
        return super.createFields + Field.allFields
    }
    override static var updateFields: [String] {
        return super.updateFields + Field.allFields
    }
    
    static var orderPath: String = Field.name.rawValue
}
