# CHFuckLocApp
修改定位的钩子应用，集成地图SDK，以及开关刷新按钮。
#项目结构
CHFuckLocApp:钩子应用的交互界面，可以直接运行，是一个与tweak交互和开关设置应用。需要越狱。MVC模式设计，包含地图SDK还有AMViralSwitch
OtherResource

||chfuckloc:主要tweak

||打包范例

||||makePackage.sh:打包deb脚本

||||Package

||||||Application:.app应用

||||||Library:tweak编译的dylib和plist设置文件

||||||DEBIAN:others
#主要功能
点击地图获取经纬度，然后点击开关可以实现定位更改。

点击刷新获取位置刷新(在开关开启时)
