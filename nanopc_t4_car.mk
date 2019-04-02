$(call inherit-product, device/rockchip/rk3399/nanopc_t4.mk)

PRODUCT_NAME := nanopc_t4_car
PRODUCT_DEVICE := nanopc-t4
PRODUCT_BRAND := Android
PRODUCT_MODEL := NanoPC-T4 (RK3399)
PRODUCT_MANUFACTURER := FriendlyELEC (www.friendlyarm.com)


PRODUCT_PROPERTY_OVERRIDES += \
	config.default_display_rotation=1
