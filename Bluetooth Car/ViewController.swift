//
//  ViewController.swift
//  Bluetooth Car
//
//  Created by Tran Thai Phuoc on 2016-07-21.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Cocoa
import ORSSerial

class ViewController: NSViewController, ORSSerialPortDelegate {

  let baudRates = [9600, 38400]
  var port: ORSSerialPort?
  var baudRate: Int = 0
  
  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var baudRatePop: NSPopUpButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Transform Int arr to String arr
    let baudStrings = baudRates.map {
      String($0)
    }
    
    baudRate = baudRates[0]
    baudRatePop.addItemsWithTitles(baudStrings)
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  // MARK: - ORSSerialPort Delegate

  func serialPortWasOpened(serialPort: ORSSerialPort) {
    statusLabel.stringValue = "Connected"
  }
  
  func serialPortWasClosed(serialPort: ORSSerialPort) {
    statusLabel.stringValue = "Disconnected"
  }
  
  func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
    statusLabel.stringValue = "Removed"
  }
  
  func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
    print(error.localizedDescription)
    statusLabel.stringValue = error.localizedDescription
  }
  
  // MARK: - IBAction Methods
  
  @IBAction func statusButtonPressed(sender: NSButton) {
    if port == nil {
      // Connect to port
      port = ORSSerialPort(path: "/dev/cu.HC-01-DevB")
      port?.delegate = self
      port?.baudRate = baudRate
      port?.open()
      sender.title = "Disconnect"
      return
    }
    // Close connection if already connected
    port?.close()
    sender.title = "Connect"
  }

  @IBAction func baudRateChanged(sender: NSPopUpButton) {
    // Apply baud rate
    let index = sender.indexOfSelectedItem
    baudRate = baudRates[index]
    port?.baudRate = baudRate
  }
  
  // MARK: - Car Movements
  
  @IBAction func movePressed(sender: NSButton) {
    let id = sender.identifier!
    sendStringToPort(id)
  }
  
  // MARK: - Helper Methods
  
  /**
   * Converts string to NSData with UTF8 encoding.
   * Then sends the data to port.
   * - parameters:
   *   - str: String to send to port
   */
  func sendStringToPort(str: String) {
    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
    if (data != nil) {
      port?.sendData(data!)
    }
  }
  
}

