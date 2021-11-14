$asset = Read-Host "What info on the chromebook do you have?"
gam print cros query $asset | gam csv - gam info cros ~deviceId basic