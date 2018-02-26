//
//  Quote.swift
//  Consumer
//
//  Created by Nicholas McDonald on 2/21/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import SmartStore

class Quote: Record, StoreProtocol {
    static let objectName: String = "SBQQ__Quote__c"
    
    enum Field: String {
        case createdById = "CreatedById"
        case quoteId = "Id"
        case quoteNumber = "Name"
        case ownerId = "OwnerId"
        case account = "SBQQ__Account__c"
        case opportunity = "SBQQ__Opportunity2__c"
        case pricebookId = "SBQQ__PricebookId__c"
        case pricebook = "SBQQ__Pricebook__c"
        case status = "SBQQ__Status__c"
        case key = "SBQQ__Key__c"
        
        static let allFields = [createdById.rawValue, quoteId.rawValue, quoteNumber.rawValue, ownerId.rawValue, account.rawValue, opportunity.rawValue, pricebookId.rawValue, pricebook.rawValue, status.rawValue, key.rawValue]
    }
    
    var ownerId: String? {
        get {return  self.data[Field.ownerId.rawValue] as? String}
        set { self.data[Field.ownerId.rawValue] = newValue }
    }
    var opportunity: String? {
        get {return self.data[Field.opportunity.rawValue] as? String}
        set { self.data[Field.opportunity.rawValue] = newValue }
    }
    var quoteId: String? {
        get {return self.data[Field.quoteId.rawValue] as? String}
        set { self.data[Field.quoteId.rawValue] = newValue }
    }
    var status: String? {
        get {return self.data[Field.status.rawValue] as? String}
        set { self.data[Field.status.rawValue] = newValue }
    }
    var pricebookId: String? {
        get {return self.data[Field.pricebookId.rawValue] as? String}
        set { self.data[Field.pricebookId.rawValue] = newValue }
    }
    var quoteNumber: String? {
        get {return self.data[Field.quoteNumber.rawValue] as? String}
        set { self.data[Field.quoteNumber.rawValue] = newValue }
    }
    var account: String? {
        get {return self.data[Field.account.rawValue] as? String}
        set { self.data[Field.account.rawValue] = newValue }
    }
    var createdById: String? {
        get {return self.data[Field.createdById.rawValue] as? String}
        set { self.data[Field.createdById.rawValue] = newValue }
    }
    var key: String? {
        get {return self.data[Field.key.rawValue] as? String}
        set { self.data[Field.key.rawValue] = newValue }
    }
    
    override static var indexes: [[String : String]] {
        return super.indexes + [
            ["path" : Field.opportunity.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.ownerId.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.pricebook.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.quoteNumber.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.account.rawValue, "type" : kSoupIndexTypeString],
            ["path" : Field.key.rawValue, "type" : kSoupIndexTypeString]
        ]
    }
    
    override static var readFields: [String] {
        return super.readFields + Field.allFields
    }
    override static var createFields: [String] {
        return super.createFields + [Field.ownerId.rawValue, Field.account.rawValue, Field.opportunity.rawValue, Field.pricebookId.rawValue, Field.status.rawValue]
    }
    override static var updateFields: [String] {
        return super.updateFields + Field.allFields
    }
    
    static var orderPath: String = Field.key.rawValue
}