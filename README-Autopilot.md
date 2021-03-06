Running Autopilot tests
=======================

The Weather app follows a test driven development where autopilot tests are run before every merge into trunk. If you are submitting your bugfix/patch to the Weather app, please follow the following steps below to ensure that all tests pass before proposing a merge request.

If you are looking for more info about Autopilot or writing AP tests for the weather app, here are some useful links to help you:

- [Ubuntu - Quality](http://developer.ubuntu.com/start/quality)
- [Ubuntu - Autopilot](https://developer.ubuntu.com/api/autopilot/python/1.5.0/)

For help and options on running tests, see:

- [Autopilot Tests](https://developer.ubuntu.com/en/start/platform/guides/running-autopilot-tests/)

Prerequisites
=============

Install the following autopilot packages required to run the tests,

    $ sudo apt-get install python3-autopilot libautopilot-qt ubuntu-ui-toolkit-autopilot python3-autopilot-vis

Running tests on the desktop
============================

Using terminal:

*  Branch the Weather app code, for example,

    $ bzr branch lp:ubuntu-weather-app
    
*  Navigate to the tests/autopilot directory.

$ cd ubuntu-weather-app/tests/autopilot

*  run all tests.

    $ autopilot3 run -vv ubuntu_weather_app

* to list all tests:

    $ autopilot3 list ubuntu_weather_app

 To run only one test (for instance: ubuntu_weather_app.tests.test_empty_state.TestEmptyState.test_add_location_button)

    $ autopilot3 run -vv ubuntu_weather_app.tests.test_empty_state.TestEmptyState.test_add_location_button

* Debugging tests using autopilot vis

    $ autopilot3 launch -i Qt qmlscene app/ubuntu-weather-app.qml

    $ autopilot3 vis

Running tests using Ubuntu SDK
==============================

Refer this [tutorial](https://developer.ubuntu.com/en/start/platform/guides/running-autopilot-tests/) to run tests on Ubuntu SDK: 

Running tests on device or emulator:
====================================

Using autopkg:

*  Branch the Weather app code, for example,

    $ bzr branch lp:ubuntu-weather-app

*  Navigate to the source directory.

    $ cd ubuntu-weather-app

*  Build a click package
    
    $ click-buddy .

*  Run the tests on device (assumes only one click package in the directory)

$ adt-run . *.click --- ssh -s adb -- -p <PASSWORD>

