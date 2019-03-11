include device/rockchip/rk3399/BoardConfig.mk

TARGET_BOARD_PLATFORM_PRODUCT := tablet

PRODUCT_PACKAGE_OVERLAYS := device/rockchip/rk3399/nanopc-t4/overlay

BOARD_SENSOR_ST := true
BOARD_SENSOR_MPU_PAD := false
BUILD_WITH_GOOGLE_GMS_EXPRESS := false

# Disable AFBC for HDMI binded to vopb
BOARD_USE_AFBC_LAYER := false
