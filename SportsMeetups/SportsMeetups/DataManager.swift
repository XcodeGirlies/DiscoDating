//
//  DataManager.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 4/1/24.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    var currentUser: User?
    
    private init() {}
}
