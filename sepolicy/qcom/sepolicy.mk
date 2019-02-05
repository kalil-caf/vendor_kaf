#
# This policy configuration will be used by all qcom products
# that inherit from Lineage
#

BOARD_SEPOLICY_DIRS += \
    vendor/kaf/sepolicy/qcom/common \
    vendor/kaf/sepolicy/qcom/$(TARGET_BOARD_PLATFORM)
