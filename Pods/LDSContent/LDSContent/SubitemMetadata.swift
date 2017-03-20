//
//  SubitemMetadata.swift
//  Pods
//
//  Created by Stephan Heilner on 1/30/17.
//
//

import Foundation

public struct SubitemMetadata: Hashable {
    public let itemID: Int64
    public let subitemID: Int64
    public let docID: String
    public let docVersion: Int
    
    public init(itemID: Int64, subitemID: Int64, docID: String, docVersion: Int) {
        self.itemID = itemID
        self.subitemID = subitemID
        self.docID = docID
        self.docVersion = docVersion
    }
    
    public var hashValue: Int {
        return "\(itemID),\(subitemID),\(docID),\(docVersion)".hashValue
    }
}

public func == (lhs: SubitemMetadata, rhs: SubitemMetadata) -> Bool {
    return lhs.itemID == rhs.itemID && lhs.subitemID == rhs.subitemID && lhs.docID == rhs.docID && lhs.docVersion == rhs.docVersion
}
