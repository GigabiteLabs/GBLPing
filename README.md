# GBLPing

Splendidly detailed network and datalink-layer operations, tests, and utilities for Swift apps.

###What is GBLPing?

A Powerful, lightweight, and super fast framework that makes the often-difficult task of getting detailed network and datalink-layer information from the devices running your application.

Benefits:

- Fine-grained control over host reachability operations
- Gets detailed network interface information about the local device
- Enables retrieval of remote MAC addresses within local networks
- Enabled capture and storage of actual packets as `Codable` Swift objects (see docs for `GBLPingResult`)
- Fully documented in DocC

[Note: some of this documentation is about features that are not yet exposed]

## Get it

Available via:

- Swift Package Manager: [Github](https://github.com/GigabiteLabs/GBLPing.git)

## Usage

You can run the test project from `Projects/GBLPingExample/GBLPingExample.xcodeproj` and view the source for a functional example. Also, see [Unit Tests](#unit-tests) for information on tests, which also have implementation examples.

Implementation samples:

### Network Utilities

**Reachability**

Check if the device is online and able to reach the internet

```swift
import GBLPing
...
Ping.network.isReachable { reachable in
   switch reachable {
	case true:
		proceedWithOperation()
	case false:
		handleOfflineOptions()
	}
}

// Note: this will ping cloudflare’s 
// nameserver `ns.cloudflare.com`
```

<br>

### Hostname Utilities

**Reachability**

Check if a given host is reachable by hostname

```swift
import GBLPing
...

Ping.host.isReachable(hostname: “google.com”) { reachable in
    switch reachable {
    case true:
        handleForTrue()
    case false:
        handleForFalse()
    }
}

```

**Ping Hosts**

Ping a given host by hostname continuously without stopping

```swift
import GBLPing
...

Ping.svc.pingHostname(
   hostname: gigabitelabs.com,
   maxPings: maxAttempts) { (reachable) in
	// process only after all attempts 
	// have succeeded
	switch reachable {
	case true:
		proceedWithOperation()
	case false:
		handleOfflineOptions()
	}
}

```

Ping a given host by hostname, but limit the total pings to a given number

```swift
import GBLPing
...

GBLPing.svc.pingHostname(
   hostname: gigabitelabs.com,
   maxPings: maxAttempts) { (reachable) in
	// process only after all attempts 
	// have succeeded
	switch reachable {
	case true:
		proceedWithOperation()
	case false:
		handleOfflineOptions()
	}
}

```


### Local Device Utilities

**Network Interfaces**

Get a list of the local device’s network interfaces

```swift
import GBLPing
...
// TODO: Docs

```

**Network Interface Names**

Get the names of all local network interfaces

```swift
import GBLPing
...
// TODO: Docs

```

**Network Interface Info**

Get information about a given network interface

```swift
import GBLPing
...
// TODO: Docs

```

## Unit Tests

- Clone the repository
- `cd` to root
- Open Package.swift, or the .xcworkspace
- Select the appropriate target device
- Run tests

No UI tests are currently available, however, there IS a test project that will let you quickly run the implementation and view ping data.

Run the test project from `Projects/GBLPingExample/GBLPingExample.xcodeproj`

## Notes

**Typealiases**

- `GBLPing` is typealiased to `Ping` for convenience and simplicity


## Acknowledgements

This framework is a mixed Swift & Obj-C package that contains work by Apple and a few others. 

- SimplePing: https://developer.apple.com/library/archive/samplecode/SimplePing/Introduction/Intro.html
- MacFinder: https://github.com/mavris/MacFinder
