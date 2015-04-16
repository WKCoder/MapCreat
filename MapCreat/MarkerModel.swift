//
//  MarkerModel.swift
//  MapCreat
//
//  Created by Wilkon on 4/11/15.
//  Copyright (c) 2015 Wilkon. All rights reserved.
//

import Cocoa

class MarkerModel: NSObject {
    var name: String = ""
    var address: String = ""
    var location: String = ""
    override init() {
        super.init()
    }
    init(name: String, address: String, location: String) {
        super.init()
        self.name = name
        self.address = address
        self.location = location
    }
    
    override var description: String {
        return "{type: \"Marker\", name: \"\(name)\", desc: \"\(address)\", color: \"red\", icon: \"cir\", offset: {x: -9, y: -31}, lnglat: {\(location)}}"
    }
    
}
