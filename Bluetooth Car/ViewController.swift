//
//  ViewController.swift
//  Bluetooth Car
//
//  Created by Tran Thai Phuoc on 2016-07-21.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Cocoa
import ORSSerial

/**
 * Receives key press and release event.
 */
protocol ViewControllerDelegate {
  /**
   * Receives key event.
   * - Parameters:
   *   - theEvent: NSEvent with Keycode
   */
  func keyPressed(theEvent: NSEvent)
  /**
   * Receives key event.
   * - Parameters:
   *   - theEvent: NSEvent with Keycode
   */
  func keyReleased(theEvent: NSEvent)
}

class ViewController: NSViewController, ViewControllerDelegate, ORSSerialPortDelegate {

  /** Constant baud rates */
  let baudRates = [300, 12200, 2400, 4800, 9600, 19200, 38400, 57600, 74880, 115200, 230400, 2500000]
  
  /** All ports detected by the system */
  let ports = ORSSerialPortManager().availablePorts
  var port: ORSSerialPort?
  
  /** Autopilot boolean mode */
  var autopilotMode = false
  
  /** Current baud rate */
  var baudRate: Int = 0
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var statusLabel: NSTextField!
  @IBOutlet weak var hintLabel: NSTextField!
  @IBOutlet weak var copyrightLabel: NSTextField!
  @IBOutlet weak var autopilotToggle: NSButton!
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
    hintLabel.stringValue = "Use W, A, S, D for directional movement, X to toggle Autopilot mode."
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  // MARK: - ORSSerialPort Delegate

  func serialPortWasOpened(serialPort: ORSSerialPort) {
    print("Connected to \(serialPort.name) with baud rate \(serialPort.baudRate)")
    statusLabel.textColor = NSColor.blueColor()
    statusLabel.stringValue = "Connected"
    autopilotToggle.enabled = true
    autopilotToggle.state = NSOffState
    autopilotMode = false
  }
  
  func serialPortWasClosed(serialPort: ORSSerialPort) {
    print("Disconnected with \(serialPort.name)")
    statusLabel.textColor = NSColor.blackColor()
    statusLabel.stringValue = "Disconnected"
    autopilotToggle.enabled = false
  }
  
  func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
    print("Removed \(serialPort.name) from system")
    statusLabel.textColor = NSColor.blackColor()
    statusLabel.stringValue = "Removed"
  }
  
  func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
    print("Error: \(error.localizedDescription)")
    statusLabel.textColor = NSColor.redColor()
    statusLabel.stringValue = "Error: \(error.localizedDescription)"
  }
  
  // MARK: - View Controller Delegate
  
  /**
   * Processes and send the appropriate command
   * based on the key pressed. Only W, A, S, D
   * and X are available.
   * - Parameters:
   *   - theEvent: NSEvent with Keycode
  */
  func keyPressed(theEvent: NSEvent) {
    if port != nil {
      switch theEvent.keyCode {
      case 0x0D: // W
        sendStringToPort("f")
        break
      case 0x01: // S
        sendStringToPort("b")
        break
      case 0x00: // A
        sendStringToPort("l")
        break
      case 0x02: // D
        sendStringToPort("r")
        break
      case 0x07: // X
        // Toggle Autopilot mode
        if (autopilotMode) {
          sendStringToPort("s")
        } else {
          sendStringToPort("a")
        }
        toggleAutoPilotMode()
        break
      default:
        break
      }
    }
  }
  
  /**
   * Send the stop command when either W, A, S, D
   * is released to stop the car.
   * - Parameters:
   *   - theEvent: NSEvent with Keycode
  */
  func keyReleased(theEvent: NSEvent) {
    if port != nil {
      switch theEvent.keyCode {
      case 0x00:
        fallthrough
      case 0x01:
        fallthrough
      case 0x02:
        fallthrough
      case 0x0D:
        // Stop the car
        sendStringToPort("s")
        break
      default:
        break
      }
    }
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
    statusLabel.textColor = NSColor.blackColor()
    statusLabel.stringValue = "No Connection"
  }

  @IBAction func baudRateChanged(sender: NSPopUpButton) {
    // Apply baud rate
    let index = sender.indexOfSelectedItem
    baudRate = baudRates[index]
    port?.baudRate = baudRate
  }
  
  // MARK: - Car Movements
  
  @IBAction func movePressed(sender: NSButton) {
    var id = sender.identifier!
    if (id == "a") {
      id = toggleAutoPilotMode()
    }
    sendStringToPort(id)
  }
  
  /**
   * Toggles the autopilot variable and the check button.
   * - Returns: either "a" or "s" depends on the autopilot
   * state.
  */
  func toggleAutoPilotMode() -> String {
    if (autopilotMode) {
      autopilotMode = !autopilotMode
      autopilotToggle.state = NSOffState
      return "s"
    } else {
      autopilotMode = !autopilotMode
      autopilotToggle.state = NSOnState
      return "a"
    }
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
      if let uwPort = port {
        uwPort.sendData(data!)
        print("Send '\(str)' with baud rate \(uwPort.baudRate)")
      }
    }
  }
  
}

