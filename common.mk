# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.setupwizard.rotation_locked=true


# RecueParty? No thanks.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.enable_rescue=false

# Mark as eligible for Google Assistant
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.opa.eligible_device=true

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# disable ADB authentication if not on user build
ifneq ($(TARGET_BUILD_VARIANT),user)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/kaf/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/kaf/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/kaf/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/kaf/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/kaf/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Changelog
#ifeq ($(KAF_RELEASE),true)
#PRODUCT_COPY_FILES +=  \
#    vendor/kaf/prebuilt/common/etc/Changelog.txt:system/etc/Changelog.txt
#else
GENERATE_CHANGELOG := true
#endif

# Dialer fix
PRODUCT_COPY_FILES +=  \
    vendor/kaf/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/kaf/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/kaf/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Copy all Kaf-specific init rc files
$(foreach f,$(wildcard vendor/kaf/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/kaf/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/kaf/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    libemoji \
    libsepol \
    e2fsck \
    bash \
    powertop \
    fibmap.f2fs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal \
    libbthost_if \
    WallpaperPicker

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

#RCS
PRODUCT_PACKAGES += \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# World APN list
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/kaf/overlay/common
DEVICE_PACKAGE_OVERLAYS += vendor/kaf/overlay/common

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/kaf/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/kaf/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif

# include sounds from pixel
$(call inherit-product-if-exists, vendor/kaf/google/sounds/PixelSounds.mk)

# build official builds with private keys
ifeq ($(KAF_RELEASE),true)
include vendor/kaf-priv/keys.mk
endif

# include definitions for SDCLANG
include vendor/kaf/build/sdclang/sdclang.mk

# Kaf versions.
CAF_REVISION := $(shell sed '5q;d' .repo/manifest.xml | sed 's/.*tags\/\(.*\)".*/\1/')
KAF_VERSION_CODENAME := 1.1
PLATFORM_VERSION_FLAVOUR := Pie

ifndef KAF_BUILD_TYPE
ifeq ($(KAF_RELEASE),true)
    KAF_BUILD_TYPE := RELEASE
    KAF_POSTFIX := -$(shell date +"%Y%m%d")
else
    KAF_BUILD_TYPE := COMMUNITY
    KAF_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif
endif

ifdef KAF_BUILD_EXTRA
    KAF_POSTFIX := -$(KAF_BUILD_EXTRA)
endif

# Set all versions
KAF_VERSION := KafC-v$(KAF_VERSION_CODENAME)-$(PLATFORM_VERSION_FLAVOUR)-$(KAF_BUILD_TYPE)$(KAF_POSTFIX)
KAF_MOD_VERSION := Kaf-v$(KAF_VERSION_CODENAME)-$(PLATFORM_VERSION_FLAVOUR)-$(KAF_BUILD)-$(KAF_BUILD_TYPE)$(KAF_POSTFIX)
CUSTOM_FINGERPRINT := Kaf/$(PLATFORM_VERSION)/$(KAF_VERSION_CODENAME)/$(TARGET_PRODUCT)/$(shell date +%Y%m%d-%H:%M)

# Kaf Bloats
PRODUCT_PACKAGES += \
    Camera2 \
    Launcher3 \
    LatinIME \
    LiveWallpapersPicker \
    SnapdragonGallery \
    MusicFX \
    Calendar \
    FirefoxLite

# TCP Connection Management
PRODUCT_PACKAGES += tcmiface
PRODUCT_BOOT_JARS += tcmiface

# Turbo
PRODUCT_PACKAGES += Turbo
PRODUCT_COPY_FILES += \
    vendor/kaf/prebuilt/common/etc/permissions/privapp-permissions-turbo.xml:system/etc/permissions/privapp-permissions-turbo.xml \
    vendor/kaf/prebuilt/common/etc/sysconfig/turbo-sysconfig.xml:system/etc/sysconfig/turbo-sysconfig.xml
