THEOS_DEVICE_IP = 192.168.199.126
ARCHS = armv7 arm64
TARGET = iphone:latest:7.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CHFuckLoc
CHFuckLoc_FILES = Tweak.xm ./LCBridge.m
CHFuckLoc_FRAMEWORKS = UIKit CoreLocation 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
