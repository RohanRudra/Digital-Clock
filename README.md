# ⏰ Digital Clock System using Verilog

## Overview

This project implements a multi-functional **digital clock system** using Verilog HDL. It features a real-time clock, stopwatch, countdown timer, and alarm functionality, all integrated into a single top-level module. The system outputs to a 7-segment display and is designed to run on an FPGA development board.

## Features

- 🕒 **Real-Time Clock (RTC)**  
  Displays the current time in HH:MM format and continuously updates every second.

- ⏱️ **Stopwatch**  
  Start, stop, and reset functionality for time measurement in MM:SS format.

- ⏳ **Countdown Timer**  
  Allows setting a custom time and counts down with an alert on completion.

- 🔔 **Alarm**  
  Set an alarm time. The system triggers an output when the alarm matches RTC.

- 🔢 **Multiplexed 7-Segment Display**  
  4-digit 7-segment display control with efficient multiplexing for time visualization.

