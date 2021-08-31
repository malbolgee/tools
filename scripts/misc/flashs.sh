#!/bin/bash

fastboot oem ssm_test 3 # Disable verity protection
fastboot reboot fastboot #fastbootd mode to flash system/product images
fastboot flash system system.img
fastboot flash system_ext system_ext.img
fastboot flash product product.img
fastboot -w
fastboot reboot

