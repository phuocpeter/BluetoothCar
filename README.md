BLUETOOTH CAR CONTROLLER
========================

Bluetooth Car Controller is an macOS application written in Swift to controller Arduino bluetooth car with HC-05. This project also used __ORSSerialPort__.

###### Personal _macOS_ project for educational and experience purpose.

Features
--------

- Connect and send commands to HC-05 with different baudrate.
- UI buttons for car movements _(forward, backward, lefward and rightward)_.
- __Autopilot mode__: with ultrasonic sensor __HY-SRF05__, the car can autopilot and avoid obstacles in front. However, this feature is not  perfect yet.
- Since this is written in __Swift__, macOS 10.10 or later is required to run.

Usage
-----

- Requires:
  - Arduino Board (Arduino Nano in this project)
  - 3V Power
  - L298
  - 2 DC Motors
  - Bluetooth HC-05
  - Ultrasonic sensor HY-SRF05

![alt text](https://github.com/phuocpeter19/BluetoothCar/blob/master/BluetoothCarWires.png?raw=true "Instruction")
- Download the [pre-compile app](https://github.com/phuocpeter19/BluetoothCar/releases/)
- Choose the bluetooth port and then click connect.
- Control the car with the UI buttons.


Compiling
---------

- Required Xcode 7.0+ and macOS 10.10.
- Open __xcworkspace__ file on a compatible Mac, compile through Xcode.

Contribute
----------

- [Issue Tracker](http://github.com/phuocpeter19/BluetoothCar/issues)
- [Source Code](http://github.com/phuocpeter19/BluetoothCar)

License
-------

The project is licensed under the __MIT license__.

```
MIT License

Copyright (c) 2016 Phuoc Tran T.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```