#Lab 10 
* Points 10
* Date due: 12/18/2014 at 5:00pm CST

##Assignment

###Getting setup
* Go to www.linode.com/trial
* Use promotion code given in class (or email instructor for it)

Once your account is activated you'll need to choose a virtual machine (VM) size and location.  My suggestion for a location is Dallas and the 1024 size, we should see something similar to the following figure:

![Choose a location](./images/choosing_a_location.png)

Once we have a location chose we'll be directed over to a screen which lists all our VMs like the following figure:

![Choose a location](./images/linode_listing.png)

Once our VM has finished being created we can click on it and get it setup! Inside of the VM configuration we can choose to 'Deploy a Linux Distribution'. For class we'll choose Ubuntu 14.04 LTS, this is the newest long term supported distribution.  Ubuntu is a common linux distribution for Rails applications. We'll also need to enter a password for the root user, choose something fairly complex but easy enough to remember.

After configuring the VM it's dashboard screen shows us a lot of information, let's explore the following figure:

![Instance dashboard](./images/dashboard.png)

On the right side of the screen we see the current status of our VM and it's usage stats. On the left top we find the control button for the VM. Let's click on 'Boot' and start the VM up.

While that is booting up, let's hop over to our Nitrous.io box and get ready to connect to our Linode VM. Rather than launching the IDE we'll just use the console.  Back in the Linode VM configuration dashbord we can go on the 'Remote Access' tab and get the information to SSH to our Linode VM.  We'll copy the SSH comand and paste it into the Nitrous.io terminal as seen in the following figure:

![Instance dashboard](./images/ssh_to_linode.png)

Now that we are SSHed into our VM let's make sure all the base packages are up to date.

```
$ apt-get update
$ apt-get upgrade
```

###Creating a deploy user
To make managing administrative access our VM let's create a group, 'wheel', that will contain users with sudo privileges.

```
/usr/sbin/groupadd wheel
```

Next we'll use the ```visudo``` command to add the wheel group to the sudoers list.

```
/usr/sbin/visudo
```

With the sudoers file open we'll add the following lines to it:

```
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
```

Then use ctrl-o to save the file followed by ctrl-x to exit the editor. With that file saved we can add our deploy user with the following command, and answer all the questions it prompts us for.

```
/usr/sbin/adduser deploy 
```

Next we'll add our deploy user to the wheel group.
```
/usr/sbin/usermod -a -G wheel deploy
```

###Installing software


##Turn in instructions
* on Blackboard under Labs find Lab 8 submit a word/text document with the following information:
  * Name
  * Date
  * Github Url of the project (can be a public repository)
  * Tag to grade

###Notes:
* If you make your github repository for labs private, you'll need to add "johnsonch" as a contributor to the repository so I can access it.
