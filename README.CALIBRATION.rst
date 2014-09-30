Introduction
============

This collection of files contains the sensor calibration information for the
`Davis Instrumented Bicycle`_ presented in [Moore2012]_.

.. _Davis Instrumented Bicycle: http://moorepants.github.io/dissertation/davisbicycle.html

Data Description
================

Each ``.mat`` file contains information for a single sensor's calibration. Some
of the files are generated from the BicycleDAQ_ ``calibrate.m`` script and some
are manually created with data from the manufacturer's sensor
specifications.The files are named as ``XXXXX.mat`` where ``XXXXX`` is a unique
sequential 5 digit number for that particular calibration. Each ``.mat`` file
contains a single structure named ``data`` and it contains the following
variables:

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
   The type of sensor, e. g. ``'LoadCell'`` or ``'potentiometer'``.

.. _BicycleDAQ: https://github.com/moorepants/BicycleDA://github.com/moorepants/BicycleDAQ

References
==========

.. [Moore2012] Moore, J. K., "Human Control of a Bicycle", UC Davis PhD
   Dissertation, 2012.
