Introduction
============

This collection of files contains data for each trial collected with the `Davis
Instrumented Bicycle`_ presented in [Moore2012]_.

.. _Davis Instrumented Bicycle: http://moorepants.github.io/dissertation/davisbicycle.html

Data Description
================

After a trial is collected via the BicycleDAQ_ software, the resulting ``.mat``
file is stored with a filename ``XXXXX.mat`` where ``XXXXX`` is a unique
sequential 5 digit number for that trial. Each ``.mat`` file contains several
variables described below.

.. _BicycleDAQ: https://github.com/moorepants/BicycleDA://github.com/moorepants/BicycleDAQ

``InputPairs``, 1 x 1 structure
-------------------------------

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
------------------------

An N x M matrix of doubles containing the time histories of the signals
collected by the NI USB-6218 DAQ box. N is the number of samples and M is the
number of signals. The columns correspond to the values in ``InputPairs`` plus
1 (for Matlab 1 indexing).

``par``, structure
------------------

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
    time, the program crashes due to software limitations.

``VNavCols``, 10 or 12 x 1 cell array
-------------------------------------

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
-------------------------------

A matrix of doubles containing the time histories of the signals collected by
the VN-100. N is the number of samples and the VN-100 reports 10 or 12 signals.
This is a lightly processed version of ``VNavDataText``. This data has NaN
values for any corrupt lines from ``VNavDataText``.

VNavDataText, ~N x 1 cell array
-------------------------------

An N x 1 cell array of chars which contain the RAW ASCII strings output by the
VN-100 at each of the N samples. Some lines are corrupted and the array may be
approximately equal to N, as some corrupted lines are interpreted as 2 corrupt
samples.

References
==========

.. [Moore2012] Moore, J. K., "Human Control of a Bicycle", UC Davis PhD
   Dissertation, 2012.
