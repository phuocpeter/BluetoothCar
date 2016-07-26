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

  let baudRates = [300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 74880, 115200, 230400, 2500000]
  let ports = ORSSerialPortManager().availablePorts
  var port: ORSSerialPort?
  var baudRate: Int = 0
  
  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var copyrightLabel: NSTextField!
  @IBOutlet weak var portsPop: NSPopUpButton!
  @IBOutlet weak var baudRatePop: NSPopUpButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Transform Int arr to String arr
    let baudStrings = baudRates.map {
      String($0)
    }
    baudRate = baudRates[4]
    baudRatePop.addItemsWithTitles(baudStrings)
    baudRatePop.selectItemAtIndex(4)
    
    let portStrings = ports.map {
      String($0)
    }
    portsPop.addItemsWithTitles(portStrings)
    portsPop.selectItemAtIndex(0)
    
    copyrightLabel.stringValue = "© 2016 Phuoc"
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  // MARK: - ORSSerialPort Delegate

  func serialPortWasOpened(serialPort: ORSSerialPort) {
    print("Connected to \(serialPort.name) with baud rate \(serialPort.baudRate)")
    statusLabel.stringValue = "Connected"
  }
  
  func serialPortWasClosed(serialPort: ORSSerialPort) {
    print("Disconnected with \(serialPort.name)")
    statusLabel.stringValue = "Disconnected"
  }
  
  func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
    print("Removed \(serialPort.name) from system")
    statusLabel.stringValue = "Removed"
  }
  
  func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
    print("Error: \(error.localizedDescription)")
    statusLabel.stringValue = error.localizedDescription
  }
  
  // MARK: - IBAction Methods
  
  @IBAction func statusButtonPressed(sender: NSButton) {
    if port == nil {
      // Connect to port
      let index = portsPop.indexOfSelectedItem
      port = ports[index]
      if let p = port {
        p.delegate = self
        p.baudRate = baudRate
        p.open()
        portsPop.enabled = false
        sender.title = "Disconnect"
      }
      return
    }
    // Close connection if already connected
    port?.close()
    port = nil
    portsPop.enabled = true
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
   * - Parameters:
   *   - str: The string to send to port
   */
  func sendStringToPort(str: String) {
    let data = str.dataUsingEncoding(NSUTF8StringEncoding)
    if (data != nil) {
      port?.sendData(data!)
      print("Send '\(str)' with baud rate \(port?.baudRate)")
    }
  }
  
}

