# Motion profile generator
A library which generates a motion profile (trapezoidal or constant) to reach a given setpoint while adhering to maximum velocity and acceleration settings. The generator is able to both calculate a complete path beforehand and generating it on the fly based on the current position and velocity.

Matlab and cpp (Arduino specific) libraries are available. It should be relatively easy to port the cpp version to other platforms.

{:toc}

## Features
* On the fly profile generation
* Supports Trapezoidal and Constant motion profiles

## Usage
```cpp
#include "MotionProfile.h"

/**
 * Initialization
 *
 * @param int aVelocityMax maximum velocity (units/s)
 * @param int aAccelerationMax maximum acceleration (units/s^2)
 * @param short aMethod method of profile generation (1 = trapezoidal)
 * @param int aSampleTime sample time (ms)
 */
MotionProfile trapezoidalProfile = new MotionProfile(200, 100, 1, 10);

/**
 * Usage
 */
 // Update setpoint for profile calculation and retrieve calculated setpoint
 float finalSetpoint = 1000;
 float setpoint = trapezoidalProfile->update(finalSetpoint)

 // Check if profile is finished
 if (trapezoidalProfile->getFinished()) {};

 // Reset internal state
 trapezoidalProfile->reset();
```

## Example graphs

## Author
This library has been developed by [Wilbert van de Ridder](http://www.github.com/WRidder) for a BSc assignment at the [University of Twente](http://www.utwente.nl).