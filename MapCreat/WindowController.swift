//
//  WindowController.swift
//  MapCreat
//
//  Created by Wilkon on 4/10/15.
//  Copyright (c) 2015 Wilkon. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    override func awakeFromNib() {
        self.window?.delegate = self
    }
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize {
        return NSMakeSize(480, 385)
    }
    
    func windowWillUseStandardFrame(window: NSWindow, defaultFrame newFrame: NSRect) -> NSRect {
        return NSMakeRect(100, 100, 480, 385)
    }
}
