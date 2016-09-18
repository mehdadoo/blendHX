BlendHX
Created with Haxe, a game engine and IDE on top of AIR capabilities.

This project is being actively developed.

![alt text](http://igloo.ir/wp-content/uploads/2015/01/blendhx-1024x583.png)
Get the latest build:
https://raw.githubusercontent.com/mehdadoo/blendHX/master/bin/blendHX.exe


You can create Entities and add Components like MeshRenderer, Sound and Camera to them.
You can import textures, and the editor takes care of encoding them to proper ATF format.
Shaders are written in HxSL, and you can change the variables of the shader using the Material properties panel.
The editor encodes your models and textures to flash bytearrays, and it runtime they are only uploaded to the GPU.
You can create Haxe(and soon Actionscript) classes, and add them to Entities as components. You can tweak the public variables of your classes from the editor GUI.

Features being developed:
Physics component via Nvidia Physx 3.3
Light component
Animation component
Blender lightmapping
Export to Andriod, iOS, Desktop, Web
