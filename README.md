# "Contacts"

A basic example project for an Apple Watch & Companion iOS App using SwiftUI and local Realm databases.

I love the Apple Watch and making apps for it. Until now I've created 'Standalone apps', but I was curious how it works with a companion app. So, I put this example together to try to learn from. Hope to improve upon it over time.

## Realm

The Watch and Companion App both have their own Realm (Good idea? Not sure). Using the [`Watch Connectivity`](https://developer.apple.com/documentation/watchconnectivity) framework messages (e.g. add and delete) are sent between watch and phone when the events occur in app.

**However**, the Watch app won't neccessarily be installed or instantiated along with the phone app. The watch app can be installed later and be none the wiser of the changes that have already occurred.

As an attempt to workaround this, the watch will request the changes from the phone (source of truth), and then update itself per the results.

I suspect I will be in syncing hell with this.

## Notes

- I would be very interested to know how people actually manage communication and persistence between watch and companion apps. I highly doubt this is how it is expected to be done.
- I suppose another way is not having two realms, and just having the watch read and write when it has connection?
- Testing 😱 Unit should be fine. But I don't think there's any UI testing capabilities with XCode and XCUITest for watch & companion apps.

## Example

![ezgif-4-866b086d5b](https://user-images.githubusercontent.com/59699224/211192249-dd077cbe-567d-4d3e-91f6-396cdbb3a38b.gif)
