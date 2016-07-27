//
//  MainWindowController.swift
//  Bluetooth Car
//
//  Created by Tran Thai Phuoc on 2016-07-27.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Cocoa

/**
 * This controller's initial purpose is to act as a delegate for
 * keyboard detection. All key pressed and released are redirected
 * to View Controller.
 */
class MainWindowController: NSWindowController {

  var viewDelegate: ViewControllerDelegate?
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Add delegate
    let vc: ViewController = (self.window?.contentViewController)! as! ViewController
    self.viewDelegate = vc
  }
  
  // MARK: - Handle Keyboard buttons
  
  override func keyDown(theEvent: NSEvent) {
    viewDelegate?.keyPressed(theEvent)
  }
  
  override func keyUp(theEvent: NSEvent) {
    viewDelegate?.keyReleased(theEvent)
  }
  
}
