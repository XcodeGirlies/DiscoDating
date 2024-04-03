//
//  Post.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var title: String?
    var user: User?
    // date of meetup
    var date: String?
    // location of meetup
    var address: String?
    // type of sport
    var sport: String?
    // post city
    var state: String?
}
