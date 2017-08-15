# Steps for creating a virtual machine to use with Rails Bridge tutorials

Start by opening up VMware Fusion and going to the file menu at the top of your screen. When you open it the menu should look similar to the screen shot below.

![](https://dl.dropboxusercontent.com/s/shl7lrq0146edly/2017-08-14%20at%209.16%20PM.png)

The wizard will prompt you to choose a "disk or image" or import from an existing PC. We're going to use the Ubuntu 16.04 (LTS) desktop image. If you don't have it downloaded you can get it from [https://www.ubuntu.com/download/desktop/thank-you?version=16.04.3&architecture=amd64](https://www.ubuntu.com/download/desktop/thank-you?version=16.04.3&architecture=amd64).

![](https://dl.dropboxusercontent.com/s/whisihydvf3yx3s/2017-08-14%20at%209.17%20PM.png)

After clicking continue you'll be taken to a screen where you can choose the disk image you downloaded. Use the button labeled "Use another disc or disc image..." and then navigate to where you saved the download to.

![](https://dl.dropboxusercontent.com/s/ckozario1imw6i6/2017-08-14%20at%209.17%20PM%20%281%29.png)

<!--![](https://dl.dropboxusercontent.com/s/ukixleshn6jdqzr/2017-08-14%20at%209.18%20PM.png)-->

Now you can use the "Linux Easy Install" feature. Fill in your name and the username and password you want to use for your virtual machine.

![](https://dl.dropboxusercontent.com/s/grsurker4q2t6q3/2017-08-14%20at%209.18%20PM%20%281%29.png)

Once you click continue you'll be taken to the finish screen, but we're not done yet! We're going to click "Customize Settings" and get our virtual machine with the proper specs.

![](https://dl.dropboxusercontent.com/s/7mlcseiqgy1f96i/2017-08-14%20at%209.18%20PM%20%282%29.png)

Before  we can customize the virtual machine we'll need to choose a spot to save the files to. I'm using an external drive. I've navigated there and changed the name to something specific. In this case 'RoR-Fall-2017'

![](https://dl.dropboxusercontent.com/s/v1aq95j3yduvaru/2017-08-14%20at%209.19%20PM.png)

After clicking save we'll be taken to the settings page where we can give our virtual machine a little more ram. ![](https://dl.dropboxusercontent.com/s/lajafnz285jw6x3/2017-08-14%20at%209.20%20PM.png)

![](https://dl.dropboxusercontent.com/s/hhqlmwbs9yndzsl/2017-08-14%20at%209.20%20PM%20%281%29.png)

I suggest at least 4 gigabytes of ram, however the amount you can give it depends on your physical machine's specifications. As we move the slider we'll see it reflect the amount of memory remaining for your computer. I would suggest keeping 2 times as much memory remaining for the host. In this case I have 16 gigabytes of ram and am only using 4 for the vm.



![](https://dl.dropboxusercontent.com/s/qsd9h2gfa6f3rzp/2017-08-14%20at%209.20%20PM%20%282%29.png)

![](https://dl.dropboxusercontent.com/s/jeddokbdg13xcl9/2017-08-14%20at%209.37%20PM.png)

![](https://dl.dropboxusercontent.com/s/9di3x7ukutb)
* `sudo apt-get update`
* `sudo apt-get upgrade` press `y` when prompted to continue

