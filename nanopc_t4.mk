#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRIV_DEVICE_PATH := device/rockchip/rk3399/nanopc-t4
TARGET_DEVICE_DIR := $(PRIV_DEVICE_PATH)

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
include device/rockchip/rk3399/nanopc-t4/BoardConfig.mk

# Quectel
$(call inherit-product-if-exists, vendor/quectel/ec20/device-partial.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, device/rockchip/rk3399/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_SHIPPING_API_LEVEL := 26

PRODUCT_NAME := nanopc_t4
PRODUCT_DEVICE := nanopc-t4
PRODUCT_BRAND := Android
PRODUCT_MODEL := NanoPC-T4 (RK3399)
PRODUCT_MANUFACTURER := FriendlyELEC (www.friendlyarm.com)

# Screen size is "normal", density is "hdpi"
PRODUCT_AAPT_CONFIG := normal large xlarge mdpi hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PACKAGES += \
    SoundRecorder

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rk.hdmisetting=true \
    ro.control_privapp_permissions=enforce

# Get the long list of APNs
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/spn-conf.xml:system/etc/spn-conf.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.version = 1.0.0 \
    ro.product.ota.host = www.rockchip.com:2300

#PRODUCT_HAVE_OPTEE := true

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml

# Camera
BOARD_CAMERA_XML_CONFIG := device/rockchip/rk3399/nanopc-t4/camera/cam_board_A.xml
PRODUCT_COPY_FILES += \
    device/rockchip/rk3399/nanopc-t4/camera/OV13850_lens_50013A1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/OV13850_lens_50013A1.xml \
    device/rockchip/rk3399/nanopc-t4/camera/OV4689.xml:$(TARGET_COPY_OUT_VENDOR)/etc/OV4689.xml

# vendor apps
$(call inherit-product-if-exists, vendor/friendlyelec/apps/device-partial.mk)

# google gms
$(call inherit-product-if-exists, vendor/google/gapps/device-partial.mk)

BUILD_WITHOUT_VENDOR_APPS := RkApkinstaller RkExplorer
