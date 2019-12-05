$(call inherit-product, device/rockchip/rk3399/nanopc_t4.mk)

PRODUCT_NAME := nanopc_t4_car
PRODUCT_DEVICE := nanopc-t4
PRODUCT_BRAND := Android
PRODUCT_MODEL := NanoPC-T4 (RK3399)
PRODUCT_MANUFACTURER := FriendlyELEC (www.friendlyarm.com)


PRODUCT_PROPERTY_OVERRIDES += \
	config.default_display_rotation=1

PRODUCT_PACKAGES += \
	SensorsApp \
	smile_auto_emu

PRODUCT_PACKAGES += \
	android.hardware.gnss@1.0-impl \
	gps.rk3399 \
	android.hardware.gnss@1.0-service

PRODUCT_COPY_FILES += \
	 vendor/smile/autohost/property.xml:vendor/etc/property.xml \
	 vendor/smile/autohost/scenario.xml:vendor/etc/scenario.xml
