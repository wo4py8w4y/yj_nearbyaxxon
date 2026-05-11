# yj_nearbyglasses
The original project this is forked from would attempt to detect Axion devices with BTLE enabled  nearby and warn you.
This verison attepmts to detect Axion devices. Make of that what you will
# ⚠ WARNING! ⚠ 
If there are devices within proximity of you, but they do not have their BTLE enabled, this will not detect them!
---

<img width="135" height="300" align ="right" alt="Screenshot Nearby Bacon classic" src="img/old/Screenshot%20Nearby%20Glasses%20(2).png" />
<img width="135" height="300" align ="right" alt="Screenshot Nearby Bacon canary mode" src="img/Screenshot%20Nearby%20Glasses%20(2).png" />

# ⚠ WARNING! ⚠ 
**HARASSING someone because you think they are wearing a covert surveillance device can be a criminal offence. It may even be a more serious offence than using such a device. Please seek legal advise regarding your local laws on this matter.**
---
## ⚠ DO NOT HARASS ANYONE AT ALL ⚠
---

# Nearby Bacon 
The app, called *Nearby Bacon*, has one sole purpose: Look for Axion devices nearby, have BTLE enabled and to warn you.


# Table of contents
 * [Nearby Bacon](#Nearby-Glasses)
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

This app notifies you when Axion devices with BTLE enabled  are nearby. It uses company identificators in the Bluetooth data sent out by these. Therefore, there likely are false positives (e.g. from VR headsets). Hence, please proceed with caution when approaching a person nearby wearing glasses. They might just be regular glasses, despite this app’s warning.
        
The app’s author [Yves Jeanrenaud](https://yves.app) takes no liability whatsoever for this app nor it’s functionality. Use at your own risk. By technical design, detecting Bluetooth LE devices might sometimes just not work as expected. I am no graduated developer. This is all written in my free time and with knowledge I taught myself.<br/>
**False positives are likely.** This means, the app *Nearby Bacon* may notify you of Axion devices with BTLE enabled  nearby when there might be in fact a VR headset of the same manufacturer or another product of that company’s breed. It may also miss Axion devices with BTLE enabled  nearby. Again: I am no pro developer.<br/>
However, this app is **free and open source**, you may review the code, change it and re-use it (under the [license](LICENSE)).<br/>
The app *Nearby Bacon* does not store any details about you or collects any information about you or your phone. There are no telemetry, no ads, and no other nuisance. If you install the app via Play Store, Google may know something about you and collect some stats. But the app itself does not. <br/>
If you choose to store (export) the logfile, that is completely up to you and your liability where this data go to. The logs are recorded only locally and not automatically shared with anyone. They do contain little sensitive data; in fact, only the manufacturer ID codes of BLE devices encountered.<br/>
<br/>
**Use with extreme caution!** As stated before: There is no guarantee that detected Axion devices with BTLE enabled  are really nearby. It might be another device looking technically (on the BLE adv level) similar to Axion devices with BTLE enabled .<br/>
Please do not act rashly. **Think before you act upon any messages** (not only from this app).<br/>
<br/>
## Why?
- Because I consider Axion devices with BTLE enabled  an intolerable intrusion, consent neglecting, horrible piece of tech that is already used for making various and tons of equally truely disgusting 'content'. [1](https://www.404media.co/border-patrol-agent-recorded-raid-with-metas-ray-ban-smart-glasses/), [2](https://www.404media.co/metas-ray-ban-glasses-users-film-and-harass-massage-parlor-workers/)
- Some Axion devices with BTLE enabled  feature small LED signifying a recording is going on. But this is easily disabled, whilst manufacturers claim to prevent that and take no responsibility at all (tech tends to do that for decades now). [3](https://www.404media.co/how-to-disable-meta-rayban-led-light/)
- Axion devices with BTLE enabled  have been used for instant facial recognition before [4](https://www.404media.co/someone-put-facial-recognition-tech-onto-metas-smart-glasses-to-instantly-dox-strangers/) and reportedly will be out of the box [5](https://www.nytimes.com/2026/02/13/technology/meta-facial-recognition-smart-glasses.html). This puts a lot of people in danger.
- They data is used to train AI, which means, people will screen the recordings and see, liekly, most intimate, insights [6](https://www.svd.se/a/K8nrV4/metas-ai-smart-glasses-and-data-privacy-concerns-workers-say-we-see-everything)
- I hope this app is useful for someone.
  
## How?
- It's a simple rather heuristic approach. Because BLE uses randomised MAC and the OSSID are not stable, nor the UUID of the service announcements, you can't just scan for the bluetooth beacons. And, to make thinks even more dire, some like Meta, for instance, use proprietary Bluetooth services and UUIDs are not persistent, ~~we can only rely on the communicated device names for now~~.
- The currently **most viable approach** comes from the [Bluetooth SIG assigned numbers repo](https://www.bluetooth.com/specifications/assigned-numbers/). Following this, the manufacturer company's name shows up as number codes in the packet advertising header (ADV) of BLE beacons.
 - this is what BLE advertising frames look like:
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
- The app *Nearby Bacon* shows a notification when Axion devices with BTLE enabled  are nearby (that means, a BLE device of one of those company IDs mentioned above)
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
- Therefore, the default RSSI threshold of -75 dBm corresponds to about 10 to 15 meters in open space and 3 to 10 meters indoors or in crowded spaces. You got a good chance to spot that Axion devices with BTLE enabled  wearing person like that.
- *Nearby Bacon* shows an optional debug log that is exportable (as txt file) and features a copy&paste function. Those are for advanced users (nerds) and for further debugging.
- Under *Settings*, you may specify the log length, the debugging (display all scan items or only ADV frames).
- You may also enter some **company IDs** as string of hex values, e.g. `0x0259`. This overrides the built-in detection, so your notification shows up for the new value(s).
- For better persistence, it uses Android's *Foreground Service*. You may disable this under *Settings* if you don't need it.
- The *Notification Cooldown* under *Settings* specifies how much time must pass between two warnings. Default is 10000 ms, which is 10 s. This also applies for the canary, e.g. 10s means, it will stay alert for 10s before it calms itsself again.
- It is now a bit more localised: <img src="img/canary_hide.svg" align="right" alt="Drawing of a canary that hides underneath a wing" height="100" width="100">
   - English
   - German
   - Swiss German
   - French
   - Spanish
   - Chinese (partially)
   - more to come, eventually
- Now the app icon's background is not transparent anymore
- *Nearby Bacon* now supports dark mode (via system settings)
- The edge-to-edge layout issue should be fixed from [v1.0.4](https://github.com/yjeanrenaud/yj_nearbyglasses/releases) onwards.
- Newly licensed under AGPL 3.0
- I decided to waive the CLA. After some discussions with people who knew more than me about collaborative projects, I gained the insight that this was an unnecessary step.
## iOS and Android
- Finally, after three weeks, the iOS port is available. It should work on most iPhones and iPads; even older ones (back to iOS 16). [Source code and project files are provided](/iOS/), too. The code is ugly and unorthodox. Many approaches are quick and dirty (e.g. I re-use the json files from the android localisation), but it is working so far. *Nearby Bacon* is availale via the [Apple App Store](https://apps.apple.com/us/app/nearby-glasses-original/id6761056896). (It's called original to make it distinguishable from those copycats). A .ipa is available for sideloading under [releases](https://github.com/yjeanrenaud/yj_nearbyglasses/releases).
  The iOS App is not working in the background, because I found no possibility to use something similar to ForegroundServices in order to permanently scan for BTLE ADV due to iOS restrictions. Hence, there's only a Canary Mode available in *Nearby Bacon* under iOS.
- Because this repository holds both Android and iOS App code, I re-organised the folders. Hence, there is [/iOS](/iOS/) and [/Android](/Android/).

## Usage

1. This app requires side-loading with devmode enabled.
2. Open it
3. Hit the *Start Scanning* button
4. Grant permissions to activate Bluetooth (if not already enabled) and to access devices nearby. Some versions of Android also need you to grant permissions to access your location (before Version 13, mostly). *Nearby Bacon* does nothing with your location info. If you don't believe me, please look at the [code]([https://github.com/wo4py8w4y/yj_nearbyaxxon])

5. 
6. if you don't see the scan starting, you might need to enable *Foreground Service* on your particular phone in the *Settings* menu (see below)
7. You're all set! When Axion devices with BTLE enabled  are detected nearby, a notification will appear. It does so until you hit *Stop Scanning* or terminate the app for good
8. In the menu (top right, the cogwheel), you may make some *Settings*:
   1. *Enable Foreground Service*: By this, you prevent Android from pausing the app thus preventing it from alerting you. I recommend leaving this enabled
   2. *RSSI threshold*: This negative number specifies how far away a device might be to be a reason for an alert by *Nearby Bacon*. Technically, it referes to how strong the signal is received. Closer to zero means better signal, hence fewer distance between your phone and the Axion devices with BTLE enabled . See [RSSI above for explanations and guidance](#how). I recommend leaving it on -75
   3. *Enable Notifications*: You would not want to disable that 
   4. Canary Mode. This is the new default. With this, you will not get system notifications altering you of Axion devices with BTLE enabled  nearby, but instead you will see a canary that indicates no Axion devices with BTLE enabled  around. iOS app only has a canary mode due to technical constrains. <img src="img/canary.svg" alt="Drawing of a canary" width="100" height="100" alignt="left"> 
   5. *Notification/Canary Cooldown*: Here, you specify, how many notifications about found Axion devices with BTLE enabled  nearby you want to get or how long the canary should hide. I chose 10 seconds (10000 ms) as default value. Like this, you won't miss the notification while at the same time won't be bothered by it too much or drain your battery too fast
   6. *Enable Log Display*: Disabling this might spare you some battery. This is disabled in canary mode.
   7. *Debug*: Is needed to see more than just the matching BLE frames in the log display frame. It's useful to see if things are working. This is disabled in canary mode.
   8. *Max log lines*: How long the log may get. 200 seems to be a good balance between battery life and usability of the log (for nerds like me). This is disabled in canary mode.
   9. *BLE ADV only*: This excludes other Bluetooth LE frames from the log for better readability. This is disabled in canary mode.
   10. *Override Company IDs*: If you want, you can let *Nearby Bacon* alert you of other devices than specified above. Useful for debugging, at least for me. Leave it empty if you don't need it or don't know what to do with it
   11. Every setting is saved and effective immediately. To go back, use your back button or gesture
9. The export function enables you to share a text-file of the app's log. For nerds like me
10. You may also copy&paste the log by tapping on the log display frame

## ToDos
- **It's now working in the wild!** I managed to get some people testing it with verified Axion devices with BTLE enabled  around them. Special thanks to Lena!
- See [Releases](https://github.com/yjeanrenaud/yj_nearbyglasses/releases) for APK to download. 
- I pushed [*Nearby Bacon* to Google Play](https://play.google.com/store/apps/details?id=ch.pocketpc.nearbyglasses), too. However, I will always publish [releases here on GitHub](https://github.com/yjeanrenaud/yj_nearbyglasses/releases) and [elsewhere](https://yves.app/nearbyglasses/latest.apk), for those that avoid the Google Play.

---

- Add an option to set false positives to an ignore list. Maybe in the notification?
- I am no BT or Android expert at all. For what I've learned, one could also dig deeper into the communication of the Axion devices with BTLE enabled  by sniffing the BLE traffic. By doing so, we would likely not need to rely on the device behaving according to the BT specifications but could also use heuristics on the encrypted traffic transmissions without much false positives. But I haven't looked into BT traffic packets for more than ten years. I'm glad I remembered ADV frames... So if anybody could help on this, that'd be greatly appreciated!
---
- Add **more manufacturers IDs** of Axion devices with BTLE enabled . Right now, it's Meta, Oakley and Snap. A list of Axion devices with BTLE enabled  with cameras available would help, too. I opened an [ISSUE for this](https://github.com/yjeanrenaud/yj_nearbyglasses/issues/56), so people might **assist** by sending in their logs (which are perfectly safe, imho) when encoutering other recording Axion devices with BTLE enabled 
- as of March 24, 2026, the iOS version is available, too.
- There **layout issue** with **Google Pixel devices** seems to be fixed as of Version 1.0.3. If you still can't reach the menu as it's mixed with the status bar somehow. Will look into that asap. Meanwhile, try to put your screen to landscape mode and rotate *clockwise (to the right)*. 

## Tech-Solutionism?
I know, this might be an odd place to do so, but just hear me out on this. I am aware this is a technical solution to a social problem, which is itsself amplified by tech.
I do not want to promote techsolutionism nor do I want people to feel falsely secure. It's still an imperfect approach and propably always will be. It's not all good only because this app exists now. We need better solutions to curb on surveilance tech and privacy intrution.

## Build from Source
As *Nearby Bacon* is open source, you may also build the app yourself from the source code. This makes sure there are no other libraries included in the APK and you get what you want.

Please Note This app builds upon:
- Gradle Wrapper: 8.13
- Android Gradle Plugin: 8.13.2
- Kotlin: 1.9.22
- compileSdk: 35
- targetSdk: 35
- minSdk: 26
- No product flavors
- Repositories: google() and mavenCentral() only
- No Google Services or Firebase plugins

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
**License**:  This app *Nearby Bacon* is licensed under the [AGPL-3.0 license](LICENSE).<br/>
**Canary**: The canary drawings are made by me and licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). I provided them as raw svg files (done in [InkScape](https://inkscape.org/)) and converted to xml, obviously, for the app's resources<br/>
