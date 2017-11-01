# Kisi-Challenge
Kisi Challenge project


## Getting Started

In order to run the projects you need to do the following, run the transmitter project, which acts like a KISI device (door look), and afterwards run one of the projects with or without UI.

### Transmitter project

```
1. Download the the repository
2. Open the BeaconTransmitter folder and open in Xcode the application
3. Modify the signing of the application in order to match profile and to be able to run it on your device
4. Run the application on a device which has bluetooth turned on
5. Check the console, if the app has printed “Transmitting”, everything is OK and your device simulates a lock
```

### Challenge 1

Now that the lock is simulated, we need to run the actual challenge apps. For the one without UI, the steps are the following:

```
1. Download the repository
2. Open the Receiver folder
3. Open the Receiver Xcode project
4. Modify the signing of the application in order to match profile and to be able to run it on your device
5. Make sure that the lock ID constant from DoorUnlockService.swift  line 16 corresponds with a valid door lock which can be obtained from “'https://api.getkisi.com/locks' -H 'Authorization: KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c'   -X   GET   —verbose”
6. Run the application
7. If the devices are closed one to another the “unlock” will happen, otherwise you can see the current status on the label on the screen on in the console

```
### Challenge 2

For the application which has an UI interface make the following:

```
1. Download the repository
2. Open the ReceiverWithUI folder
3. Open the Receiver Xcode project
4. Modify the signing of the application in order to match profile and to be able to run it on your device
5. Make sure that the lock ID constant from DoorUnlockService.swift  line 16 corresponds with a valid door lock which can be obtained from “'https://api.getkisi.com/locks' -H 'Authorization: KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c'   -X   GET   —verbose”
6. Run the application
7. If the devices are closed one to another the lock will open, otherwise if the devices are away the lock will close or as well if the devices are out of range

```

### Video

http://bit.ly/2io8JuW
