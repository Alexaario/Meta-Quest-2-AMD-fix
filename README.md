# Meta-Quest-2-AMD-fix

This is a script that runs in the background checking if Meta Quest 2 headset is plugged in. If so, it will edit registry to disable an option called "Record Desktop" in AMD Adrenaline software. 
This option causes flickering and laggy VR movement in PCVR through the link cable.

To use it create a new task in windows Task Scheduler. Make it run on startup, execute as powershell.exe and add `-WindowStyle Hidden -File "C:\Path\To\Meta2AMDFix.ps1"`.
