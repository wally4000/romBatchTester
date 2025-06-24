# romBatchTester

This is a currently basic batch rom tester for Emulator Quality assurance.

It currently is made for the daedalusX64 Emulator but will work with anything, you just need to modify the TARGET and extension.

It works by parsing in the roms folder as a list, taking a screenshot using the distribution of choice (macOS takes a full screenshots for now and will be fixed later), putting all stdout into a text file and then exports it to a HTML document which then be used as a way to determine if a game is working or not.

This can be useful for debugging purposes and seeing if there are any questionable roms that don't work.


# Linux

```sh
flatpak install com.obsproject.Studio
```

* Open OBS once to setup for recording, then create a scene called `daedalus`, save and close.

* Run it and wait
```
./batch.sh
```
