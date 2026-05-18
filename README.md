#
Forked from  yj_nearbyglasses
at GitHub.tyw majority of work and code was only copied by me.

# Nearby Glasses 
The app, called *axxon btle*, has one sole purpose: Look for Axxon devices nearby and warn you.




# Table of contents
 * [Nearby Glasses](#Nearby-Glasses)
  * [Why?](#why)
  * [How?](#how)
  * [Features](#features)
    * [What's RSSI?](#whats-rssi)
  * [iOS and Android](#ios-and-android)
  * [Usage](#usage)
  * [ToDos](#todos)
  * [Tech-Solutionism?](#tech-solutionism)
  * [Build from Source](#build-from-source)
  * [Shoutouts](#shoutouts)
  * [License and Credits](#license-and-credits)

This app notifies you when Axon devices are nearby. It uses company identificators in the Bluetooth data sent out by these. Therefore, there likely are false positives (e.g. from VR headsets). Hence, please proceed with caution when approaching a person nearby wearing glasses. They might just be regular glasses, despite this app’s warning.
        

```
Frame 1: Advertising (ADV_IND)
Time:  0.591232 s
Address: C4:7C:8D:1E:2B:3F (Random Static)
RSSI: -58 dBm

Flags:
  02 01 06
    Flags: LE General Discoverable Mode, BR/EDR Not Supported

Manufacturer Specific Data:
  Length: 0x1A
  Type:   Manufacturer Specific Data (0xFF)
  Company ID: 0x0259 (Axon Enterprise, Inc.)
  Data: 42 34 2D 58 31 32 33 34 35 36

Service UUIDs:
  Complete List of 16-bit Service UUIDs
  0xFEAA
```
- According to the [Bluetooth SIG assigned numbers repo](www.bluetooth.com/specifications/assigned-numbers/), we may use this company ID:
  - `0x0259` for `Axon Enterprise, Inc.`
    
  It is **immutable and mandatory**. Of course, Axon and other manufacturers also have other products that come with Bluetooth and may therefore share a company ID or similar naming patterns. Therefore, using this company ID and these device-name patterns for the app's scanning process is still prone to false positives, but it provides a practical heuristic for Axon Body 3, Axon Body 4, and Axon Signal Sidearm devices.
- During pairing, supported devices may also emit product names such as `B3-X[Serial_Number]`, `B4-X[Serial_Number]`, or `Signal Sidearm-[Serial_Number]`, so we can scan for those, too. But it's rare we will see that in the field. People with the intention to use such devices in bars, pubs, on the street, and elsewhere usually prepare for that beforehand.
- When the app recognised a Bluetooth Low Energy (BLE) device with a sufficient signal strength (see RSI below), it will push an alert message. This shall help you to act accordingly.

## Features
- The app *Nearby Glasses* shows a notification when smart glasses are nearby (that means, a BLE device of one of those company IDs mentioned above)
- **Nearby** means, the RSSI (signal strength) is less than or equal to a given value: -75 dBm by default. This default value corresponds to a medium distance and an ok-ish signal.
  ### What's RSSI?
- Let me explain a bit that RSSI-Value:<br/>
RSSI is short for Received Signal Strength Indication. The value is an indication for the reception field strength of wireless communication applications. [Wikipedia has a quite good article](https://en.wikipedia.org/wiki/Received_signal_strength_indicator) about it.
In short, RSSI depends mainly on:<br/>
  - Device transmit power
  - Antenna design
  - Walls and obstacles
  - Human bodies absorbing signal
  - Reflection and interference
  - Device orientation<br/>
But typical BLE (Bluetooth Low Energy) scenarios, RSSI rough distance (open space) is: <br/>
  - -60 dBm ~ 1 – 3 m<br/>
  - -70 dBm ~ 3 – 10 m<br/>
  - -80 dBm ~ 10 – 20 m<br/>
  - -90 dBm ~ 20 – 40 m<br/>
  - -100 dBm ~ 30 – 100+ m or near signal loss<br/>
Indoors, distances are often much shorter.<br/>
RSSI drops roughly according to<br/>
    `RSSI ≈ -10 * n * log10(distance) + constant`<br/>
- Therefore, the default RSSI threshold of -75 dBm corresponds to about 10 to 15 meters in open space and 3 to 10 meters indoors or in crowded spaces. You got a good chance to spot that smart glasses wearing person like that.
- *Nearby Glasses* shows an optional debug log that is exportable (as txt file) and features a copy&paste function. Those are for advanced users (nerds) and for further debugging.
- Under *Settings*, you may specify the log length, the debugging (display all scan items or only ADV frames).
- You may also enter some **company IDs** as string of hex values, e.g. `0x0259`. This overrides the built-in detection, so your notification shows up for the new value(s).
- For better persistence, it uses Android's *Foreground Service*. You may disable this under *Settings* if you don't need it.
- The *Notification Cooldown* under *Settings* specifies how much time must pass between two warnings. Default is 10000 ms, which is 10 s. This also applies for the canary, e.g. 10s means, it will stay alert for 10s before it calms itsself again.


### Requirements

- **JDK 17** (required — project targets Java 17)
- **Android SDK Platform 35** installed  
  - compileSdk = 35  
  - targetSdk = 35  
- Git
### Building APK step-by-step
```bash
#Verify Java version:

 $java -version
#It must report Java 17.

#Get the source code
 $git clone https://github.com/yjeanrenaud/yj_nearbyglasses
 $cd yj_nearbyglasses

#Build Debug
 $./gradlew clean assembleDebug

#Build Release (with your own signature cert)
 $./gradlew clean assembleRelease

#Build unsigned Release for IzzyOnDroid / F-Droid
 $./gradlew clean izziFdroid 

#Run and Test
 $./gradlew test lint
```

## Shoutouts
- [@vfrmedia@social.tchncs.de](https://social.tchncs.de/@vfrmedia) for helping me with the warnings
- [@mewsleah@meow.social](https://meow.social/@mewsleah) for pointing out the idea of a canary mode
- [@pojntfx](https://github.com/pojntfx) for pointing out my misunderstandings with licensing
- [Sarah-Jane B.](https://www.linkedin.com/in/sarah-janeb/) for UX design tipps
- Lena Radau for the translation to Spanish
- Marcel L. for feedback and testing the iOS app
- Lena Hansen for field tests
- Everyone else who already provided feedback to the app!

## License and Credits
**App Icon**: The icon is based on [Eyeglass icons created by Freepik - Flaticon](https://www.flaticon.com/free-icons/eyeglass)<br/>
**License**:  This app *Nearby Glasses* is licensed under the [AGPL-3.0 license](LICENSE).<br/>
**Canary**: The canary drawings are made by me and licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). I provided them as raw svg files (done in [InkScape](https://inkscape.org/)) and converted to xml, obviously, for the app's resources<br/>
