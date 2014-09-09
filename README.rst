BicycleDAQ
==========

This a simple graphical user interface used to collect data on the `Davis
Instrumented Bicycle`_. The software connects to both a National Instruments
USB-6218 and a VectorNav VN-100 development board through USB connections in a
laptop PC. It makes use of the Matlab Data Acquisition Toolbox, NIDAQmx driver,
and the Matlab Serial interface. It is intended to run on a netbook computer.

.. _Davis Instrumented Bicycle: http://moorepants.github.io/dissertation/davisbicycle.html

License
=======

`BSD 2-Clause License<http://opensource.org/licenses/BSD-2-Clause>`_, see
``LICENSE.txt``.

Dependencies
============

These dependencies are not necessarily that strict but were the only ones the
software was tested with.

Hardware
--------

- ASUS Eee PC 1001P-MU17-WT
- `VectorNav`_ VN-100
- `National Instruments`_ USB-6218
- `Davis Instrumented Bicycle`_

.. _VectorNav: http://www.vectornav.com
.. _National Instruments: http://www.ni.com

Software
--------

- Windows XP Pro
- Matlab (7.8.0 R2009a) + Data Acquisition Toolbox
- VectorNav Matlab Library

Usage
=====

Trial Recordings
----------------

The GUI can be run by simply starting the Matlab interpreter from the root
directory of this repository and calling the main script::

   $ matlab
   >> BicycleDAQ.m

Meta data and recording settings for the trial can be specified in the various
input cells. To initialize the system and connect to the two hardware devices,
press the "Connect" button. Once the system is connected, the "Tare" button
will tare the VN-100. When ready to start a trial press the "Record" button and
the system will wait for the handlebar button trigger to be pressed. Once the
trigger is pressed, data will be collected for the specified duration and
automatically saved to disk in a local ``data/`` directory. After the
recording, the time series traces can be inspected in the graph window by
selecting the different graph type buttons. Once recording of all the trials in
a session are completed, the "Disconnect" button will disconnect from the
hardware. Finally, the GUI window can be closed.

When not recording any previously recorded ``.mat`` file can be loaded for
graphical inspection. The meta data for that file can also be edited and
overwritten with the "Save" button.

Sensor Calibration
------------------

There are three sensors that require periodic manual calibration: the steer
angle potentiometer, the roll angle potentiometer, and the pull force load
cell. Typically, all three should be calibrated before each trial session and
at any point when there may be reason to think the sensors are no longer
calibrated. There is a single script in the ``tools/`` directory that can
calibrate each sensor using a static procedure. The script can be run with::

   $ cd tools
   $ matlab
   >> calibrate.m

A simple UI will guide the user through the calibration process. Details of the
calibration procedure can be found in the comments of ``calibrate.m`` and in
the dissertation chapter on the `Davis Instrumented Bicycle`_. Each calibration
saves a ``.mat`` file to disk, described below, in the ``data/CalibData``
directory.

Data
====

Trials
------

After a trial is collected via the GUI interface, the resulting ``.mat`` file
is stored in the `data/` directory with a filename ``XXXXX.mat`` where
``XXXXX`` is a unique sequential 5 digit number for that trial. Each ``.mat``
file contains several variables described in the following sections.

``InputPairs``, 1 x 1 structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A structure which contains key value pairs that map chars representing column
headings for the ``NIData`` matrix to integer values which correspond to a pin
number on the NI USB-6218.

- ``PushButton``: 0
- ``SteerPotentiometer``: 1
- ``HipPotentiometer``: 2
- ``LeanPotentiometer``: 3
- ``TwistPotentiometer``: 4
- ``SteerRateGyro``: 5
- ``WheelSpeedMotor``: 6
- ``FrameAccelX``: 7
- ``FrameAccelY``: 8
- ``FrameAccelZ``: 9
- ``SteerTorqueSensor``: 10
- ``SeatpostBridge1``: 11
- ``SeatpostBridge2``: 12
- ``SeatpostBridge3``: 13
- ``SeatpostBridge4``: 14
- ``SeatpostBridge5``: 15
- ``SeatpostBridge6``: 16
- ``RightFootBridge1``: 17
- ``RightFootBridge2``: 18
- ``LeftFootBridge1``: 19
- ``LeftFootBridge2``: 20
- ``PullForceBridge``: 21
- ``ThreeVolts``: 22
- ``FiveVolts``: 23
- ``RollPotentiometer``: 24

``NIData``, N x M double
~~~~~~~~~~~~~~~~~~~~~~~~

An N x M matrix of doubles containing the time histories of the signals
collected by the NI USB-6218 DAQ box. N is the number of samples and M is the
number of signals. The columns correspond to the values in ``InputPairs`` plus
1 (for Matlab 1 indexing).

par, structure
~~~~~~~~~~~~~~

A structure which contains key value pairs of the primary meta data for the
trial.

``AccelerometerCompensation``, char
    This is the raw char from the VN-100 that gives the programmable
    compensation parameters for the accelerometers.
``AccelerometerGain``, char
    This is the raw string from the VN-100 that gives the programmable gain for
    the accelerometers.
``ADOT``, 1 x 1 double
    Asynchronous Data Output Type. This tells you what the asynchronous output
    is of the VN-100. It can either be ``14`` or ``253``. ``14`` is the Kalman
    filtered data and ``253`` is the unfiltered. Refer to the VN-100
    documentation.
``Baudrate``, 1 x 1 double
    This is the baud rate at which the VN-100 is connected at.
``Bicycle``, char
    The gives the bicycle name and/or configuration.
``DateTime``, char
    The date and time of data collection. Formatted as ``DD-Month-YYYY
    HH:MM:SS``.
``Duration``, 1 x 1 double
    The duration of the run in seconds.
``Environment``, char
    This is the location, building and/or equipment where the data was taken.
    Options include: ``'Pavilion Floor'``, ``'Laboratory'``, ``'Hull
    Treadmill'``.
``FilterActiveTuningParameters``, char
    This is the raw char from the VN-100 that gives the programmable active
    tuning parameters for the Kalman filter.
``FilterTuningParameters``, char
    This is the raw char from the VN-100 that gives the programmable Kalman
    filter tuning parameters.
``FirmwareVersion``, char
    This is the raw char from the VN-100 displaying the device's firmware
    version.
``HardSoftIronParameters``, char
    This is the raw char from the VN-100 that gives the programmable hard/soft
    iron compensation parameters.
``HardwareRevision``, char
    This is the raw char from the VN-100 displaying the device's hardware
    version.
``Maneuver``, char
    The particular maneuver being performed. Some options are:

    - ``'System Test'`` : This is a generic label for data collected during
      various system tests.
    - ``'Balance'`` : The rider is instructed to simply balance the bicycle and
      keep a relatively straight heading. The rider should look into the
      distance and not focus on any close objects.
    - ``'Balance With Disturbance'`` : Same as 'Balance' except that a lateral
      force disturbance is applied to the seat of the bicycle.
    - ``'Tracking Straight Line'`` : The rider is instructed to focus on a
      straight line that is on the ground and attempt to keep the contact point
      of the front wheel aligned with the line. The line of site from the
      rider's eyes to the line on the ground should be tangent to the front of
      the front wheel.
    - ``'Tracking Straight Line With Disturbance'`` : Same as ``'Tracking
      Straight Line'`` except that a lateral perturbation force is applied to
      the seat of the bicycle.
    - ``'Lane Change'`` : The rider is instructed to perform a lane change
      trying to keep the bicycle on a line on the ground. For the Pavilion
      Floor, the line is taped on the ground and the rider is instructed to do
      whatever feels best to stay on the line. They can use full preview
      looking ahead, focus on the front wheel and line, or a combination of
      both.
    - ``'Steer Dynamics Test'`` : These are for the experiments setup to
      determine the friction in the steering column bearings.

``ModelNumber``, char
    This is the raw char from the VN-100 displaying the device's model number.
``NISampleRate``, 1 x 1 double
    The sample rate in hertz of the NI USB-6218.
``NINumSamples``, 1 x 1 double
    The number of samples taken during the run on the NI USB-6218.
``Notes``, char
    Notes about the run.
``ReferenceFrameRotation``, char
    This is the raw char from the VN-100 that gives the programmable direction
    cosine matrix.
``Rider``, char
    This gives the first name of the person riding the bicycle or 'None' if no
    one is on the bicycle while the data was taken.
``RunID``, 1 x 1 double
    The unique five digit number for the run.
``SerialNumber``, char
    This is the raw string from the VN-100 displaying the device's serial
    number.
``Speed``, 1 x 1 double
    The desired speed of the bicycle during the trial. This is slightly
    redundant, the rear wheel speed motor voltage should be used for the actual
    speed.
``VNavComPort``, char
    The Windows communications port that the VN-100 is connected to. This is
    typically ``'COM3'`` but could be others.
``VNavSampleRate``, 1 x 1 double
    The sample rate in hertz of the NI USB-6218.
``VNavNumSamples``, 1 x 1 double
    The number of samples taken for the run on the VN-100.
``Wait``, 1 x 1 double
    This is the time in seconds that the software waits for the rider to press
    the collect data trigger. If the rider doesn't push the button before this
    time, the software crashes (due to a bug).

``VNavCols``, 10 or 12 x 1 cell array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This cell array contains the ordered names of the data signals collected from
the VN-100. These depend on what ``par.ADOT`` is set to.

For ``par.ADOT = 253``, only the raw measurements are returned:

#. Mag X
#. Mag Y
#. Mag Z
#. Acceleration X
#. Acceleration Y
#. Acceleration Z
#. Angular Rate X
#. Angular Rate Y
#. Angular Rate Z
#. Temperature

For ``par.ADOT = 14`` the Kalman filtered data is returned:

#. Angular Rotation Z
#. Angular Rotation Y
#. Angular Rotation X
#. Mag X
#. Mag Y
#. Mag Z
#. Acceleration X
#. Acceleration Y
#. Acceleration Z
#. Angular Rate X
#. Angular Rate Y
#. Angular Rate Z

VNavData, N x (10 or 12) double
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A matrix of doubles containing the time histories of the signals collected by
the VN-100. N is the number of samples and the VN-100 reports 10 or 12 signals.
This is a lightly processed version of ``VNavDataText``. This data has NaN
values for any corrupt lines from ``VNavDataText``.

VNavDataText, ~N x 1 cell array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An N x 1 cell array of chars which contain the RAW ASCII strings output by the
VN-100 at each of the N samples. Some lines are corrupted and the array may be
approximately equal to N, as some corrupted lines are interpreted as 2 corrupt
samples.

Calibration
-----------

After a calibration is collected via the ``tools/calibrate.m`` script, the
resulting ``.mat`` file is stored in the `data/CalibData` directory with a
filename ``XXXXX.mat`` where ``XXXXX`` is a unique sequential 5 digit number
for that calibration. Each ``.mat`` file contains several variables described
in the following sections.

Each file contains a single structure named ``data`` and it contains the
following variables:

``accuracy``, char
   The absolute accuracy of the measurement in in calibration, e.g. ``'0.1'``.
``calibrationID``, char
   The string representation of the unique 5 digit calibration identification
   number, e.g. ``'00015'``.
``name``, char
   The name of the sensor being calibrated, e.g. ``'PullForceBridge'``.
``notes``, char
   Any notes about the specific calibration, e.g. ``'redoing calibration'``.
``offset``, 1 x 1 double
   The y-intercept for the best linear fit of the voltage to sensor output
   curve, e.g. ``-95.1499``.
``rsq``, 1 x 1 double
   The R-Squared value of the best linear fit, e.g. ``1.0000``.
``signal``, char
   The name of the sensor output, e.g. ``'PullForce'``.
``slope``, 1 x 1 double
   The slope of the best linear fit of the voltage to sensor output curve, e.g.
   ``32.7438``.
``timeStamp``, char
   The date and time of the calibration, e.g. ``'29-Aug-2011 15:48:22'``.
``x``, 400 x n double
   The NI USB voltage recorded for a 2 second duration at 200 hz (400 samples)
   at each of n data collection points.
``y``, n x 1 double
   Either the known angle or known load applied to the sensor at each of the n
   data collection points.
``v``,  n x 1 double
   The sensor power supply voltage recorded for a 2 second duration at 200 hz
   (400 samples) at each of n data collection points.
``units``, char
   The units of the recorded known angle or known load, e.g ``'pound'``.
``calibrationSupplyVoltage``, n x 1 double
   The mean voltage supplied to the sensors for power during each sampling, e.g
   ``5.0``.
``runSupplyVoltage``,  1 x 1 double
   The voltage that should be assumed for the sensor power during an actual
   trial. This is used only if the power supply voltage is not measured for
   this sensor in during trials, e.g. ``5.0``.
``runSupplyVoltageSource``: char
   The label of the voltage channel which measures the sensor's power source.
   e.g. ``'na'`` or ``'FiveVolts'``.
``sensorType``, char
   The type of sensor, either ``'LoadCell'`` or ``'potentiometer'``.
