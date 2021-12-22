# Actionscript Parallaxer
## Kick back and let the code do it for ya!
Alright lets get a couple things straight bucko, This isn't just some tool,this baby is gonna change things.

Let's start with the obvious you are going to need to put the code in your project.
Now this part is important

1) Create a new layer in your project call it `CODE` or something and press `F6` to create a new Keyframe.
2) Click that layer and press `F9` This is gonna bring up the actions code panel.
3) Paste in the parallax code, Easy part done.
4) Now if you want the preview to run right this part is important, Create another keyframe exactly ** one ** frame after the last frame of your animation
5) Click that frame and press `F9` Now all you need to do it type `cleanup()` or copy/paste it from here.
6) Now the fun part! If you are using vcam click on the first frame of your animation
7) Move all of the background elements where you want them.
8) Click each one and to go to the properties panel and give them a name.
9) Now make a note of the name we will need it later
10) Go back to the first frame of `CODE` and go to the very bottom,you are about to do some coding
11) Now choke back all your pre-conceived notions this coding session is going to be more painless than you think
12) You are going to type the following **EXACTLY** `updateLayer([layerName],[zAxis],[manualXoffset],[manualYoffset],[layerScale])`
    Replacing `[someWord]`. like this: `updateLayer("sky",1000,0,0,true)` now lets go over what they do.
    * layerName - Rememeber when I said remember the name ? This is your chance to show you can follow basic directions pick one of your layerNames and put it here
    * zAxis - This is a number that represents how *far* your layer is from the camera. This number can be whatever you want but I'll explain some ideal ranges below
        * [more than 15, less than 75] I'd call the foreground, This is **really** close to the camera
        * [more than 75, less than 500] You are going to see **much** less movement at this distance, but still some
        * [more than 500,less than 1001] This is what I'd call the background layer, This is so far your are basically going to see no movement
    * manualXOffset - *optional* - Can't drag your element to the **PERFECT** spot ? I got your back this how you fix it! positive number move it to the right and negative numbers move it to the left
    * manualYOffset - *optional* - The same as the above expect, positive is **DOWN** and negative is **UP**
    * layerScale - *optional* - This is set to either `true` or `false`, and this controls whether the layer grows as the camera zooms
13) So if you are still reading the minimum we need is something like this `updateLayer("sky",1000)`
14) Do this for every layer you want updated with parallax.

Congrats !! You now have some working parallax! Lets talk a few more details for finer control
There are two more options you can control:
scaleToCamera
offsetToCamera

`scaleToCamera` : Is a global kill switch for the Scaling on zoom if you don't want it in your project use this `config.scaleToCamera = false`
`offsetToCamera` : is the global switch to choose where set the origin for the project, by default we use the Vcam but we can also choose to use the canvas by pasting `config.scaleToCamera = false`;

Either of these can be pasted right above where you type `updateLayer(...)`

I'll end with an example.
I have 4 layers I want to parallax I'll call them ["sky","mountain","mountainTwo","mountainThree"]
and lets say **DON'T** want scaling that would look like

```javascript
    config.scaleToCamera = false;
    updateLayer("sky",1000);
    updateLayer("mountain",50);
    updateLayer("mountainTwo",90);
    updateLayer("mountainThree",180);
```
Now get back to the fun part ! animating your fight !

## If you used this project drop me some credit in your project!

###**Parallax Script - Michael Walker**

or something like that

### Thanks for reading and enjoy!