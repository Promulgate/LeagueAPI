//
//  Champion+JSON.swift
//  LeagueAPI
//
//  Created by Eric Chang on 12/27/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import Foundation

extension Champion {
    func populate(from champDict: [String:Any]) {
        
        guard let name = champDict["title"] as? String,
            let id = champDict["href"] as? Int,
            let title = champDict["ingredients"] as? String
            else { return }
        
        self.name = name
        self.id = Int32(id)
        self.title = title
    }
}
