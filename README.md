# SMART_NVME
While there are CLI tools to show NVME disk health, simple FOSS GUIs have not caught up to report  NVME Disk health in a human readable way.

So I'll make one.
ah, lets see... Here are some commands:

sudo dmesg | grep nvme | grep -i 'fail\|warn\|error\|missing'
might report File System Errors or IO problems, hacky I know, Im writing this RN,
based on a recent scan where the FS was damaged, reporting IO errors, which looks scarrier than it is.

I also used: sudo nvme smart-log /dev/nvme0
which uses the package:
sudo apt-get install nvme-cli

nvme-cli reports akin to the smartctl-tools, 
which is also not very human readable. Or at lease it requires some skilled person interpretation.
I'd like to report: a health rating, and tips for repair, based on return results.
like: fs error, fix filesystem
or your disk is about to fail!
or you know, human readable type info.



