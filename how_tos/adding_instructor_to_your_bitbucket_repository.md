
#How to add your instructor and push a tag
##Adding Instructor

Open up your repository's page and click on **Send invitation**.

![](https://dl.dropboxusercontent.com/s/r2stnmm1tzowu1d/2016-03-07%20at%2010.25%20PM.png)

That will open a dialog box which you can type in your instructors Bitbucket username: johnsonch.

![](https://dl.dropboxusercontent.com/s/09r8buxkg6zt2a1/2016-03-07%20at%2010.26%20PM.png)

Make sure your instructor has write access to your repository.

![](https://dl.dropboxusercontent.com/s/lqptxmwyjopz7m1/2016-03-07%20at%2010.26%20PM%20%281%29.png)

If you did it correctly you will get a success message.

![](https://dl.dropboxusercontent.com/s/yh2oztqsxegtqwq/2016-03-07%20at%2010.27%20PM.png)

##Creating and pushing a tag

Create your tag using the ```$ git tag <name of the tag>``` command where ```<name of the tag>``` is what your instructor indicated in the lab/project instructions. Make sure to remove the ```<``` and ```>``` from the tag name.

![](https://dl.dropboxusercontent.com/s/c4nin28oyoaocq1/2016-03-07%20at%2010.27%20PM%20%281%29.png)

Then push your tags to the remote repository (Bitbucket) with ```$ git push --tags```

![](https://dl.dropboxusercontent.com/s/7ljl92ma54hgtjx/2016-03-07%20at%2010.28%20PM.png)

You can verify the tag was pushed by going to your repositories page and viewing the tags.

![](https://dl.dropboxusercontent.com/s/ygcel3gh1yz1ao9/2016-03-07%20at%2010.29%20PM%20%281%29.png)