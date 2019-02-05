# Kaf sprcific build properties
ADDITIONAL_BUILD_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    kaf.ota.version=$(KAF_MOD_VERSION) \
    ro.caf.revision=$(CAF_REVISION) \
    ro.kaf.buildtype=$(KAF_BUILD_TYPE) \
    ro.kaf.flavour=$(KAF_VERSION_FLAVOUR) \
    ro.kaf.version=$(KAF_VERSION_CODENAME)-$(KAF_VERSION_FLAVOUR) \
    ro.custom.fingerprint=$(CUSTOM_FINGERPRINT) \
    ro.modversion=$(KAF_MOD_VERSION)