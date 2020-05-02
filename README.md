## BOINC runner
This project should run on Pi Zero/One/Two devices with 1GB of RAM:
* Raspberry Pi Zero/One/Two (1GB RAM)

This project runs three random ARM projects from:
* https://boinc.berkeley.edu/projects.php

## Getting started

This is a containerized application intended to run on [balenaCloud](https://www.balena.io/cloud/), which allows you to deploy it to an entire fleet of devices and get as many of them folding as quickly as possible for the least effort. 

### Setup the device(s)

* Sign up for or login to the [balenaCloud dashboard](https://dashboard.balena-cloud.com)
* Create an application, selecting the correct device type
* Add a device to the application, enabling you to download the OS
* Flash the downloaded OS to your SD card with [balenaEtcher](https://balena.io/etcher)
* Power up the Pi and check it's online in the dashboard

### Deploy this application

* Install the [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)
* Login with `balena login`
* Download this project and from the project directory run `balena push <appName>` where `<appName>` is the name you gave your balenaCloud application in the first step.
* The application will then be downloaded and started by each device in your fleet.

### Check the status

This project has a built in web interface that allows you to see statistics and more. Simply visit the local IP address of your device or [enable the public URL for your device](https://www.balena.io/docs/learn/manage/actions/#enable-public-device-url) in the balenaCloud dashboard and you'll be able to access statistics from anywhere!

The web interface uses [GoTTY](https://github.com/yudai/gotty) to provide access to `boinctui` via a standard web browser.

## Customization

You can set your account project authentication key by using the [environment variable](https://www.balena.io/docs/learn/manage/serv-vars/) `XXX_KEY`, set from the balenaCloud dashboard. 

This will automatically update the XML configuration file with your key and ensure you're credited for completed work units.
