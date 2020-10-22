# MacPowerTools
Tools to enable or disable user sleep and timer coalescing (App Nap) in Qt applications for MacOS.

Allows applications that need to keep running in the background (serial port, data logging, etc) to continue uninterrupted without the need to enable or disable power management features system-wide (ie completely disabling sleep or App Nap).


# Use:
In the project file:

```C
macx {
  HEADERS += macpowertools.h
  OBJECTIVE_SOURCES += macpowertools.mm
  LIBS += -framework Foundation
}
```

In the code:

```C
// prevent app nap and user sleep
disableAppNap();
preventSleep();

// do latency-sensitive stuff

// restore app nap and user sleep settings
enableAppNap();
allowSleep();
```
# License:
MIT
