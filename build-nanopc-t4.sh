#!/bin/bash

# ----------------------------------------------------------
# base setup

UBOOT_DIR=u-boot
UBOOT_CFG=rk3399_defconfig

KERNEL_DIR=kernel
KERNEL_CFG=nanopi4_oreo_defconfig
KERNEL_IMG=nanopi4-images

PRODUCT="nanopc_t4"
VARIANT="userdebug"

#----------------------------------------------------------
# local functions

NR_CPU=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')
MAKE="make -j${NR_CPU}"

if grep "Ubuntu 18.04" /etc/lsb-release >/dev/null 2>&1; then
	export LC_ALL=C
fi

start_time=$(date +"%s")

FA_ShowTime() {
	local ret=$1
	local end_time=$(date +"%s")
	local tdiff=$(($end_time-$start_time))
	local hours=$(($tdiff / 3600 ))
	local mins=$((($tdiff % 3600) / 60))
	local secs=$(($tdiff % 60))
	local ncolors=$(tput colors 2>/dev/null)
	if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
		color_failed=$'\E'"[0;31m"
		color_success=$'\E'"[0;32m"
		color_reset=$'\E'"[00m"
	else
		color_failed=""
		color_success=""
		color_reset=""
	fi
	echo
	if [ $ret -eq 0 ] ; then
		echo -n "${color_success}#### make completed successfully "
	else
		echo -n "${color_failed}#### make failed to build some targets "
	fi
	if [ $hours -gt 0 ] ; then
		printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs
	elif [ $mins -gt 0 ] ; then
		printf "(%02g:%02g (mm:ss))" $mins $secs
	elif [ $secs -gt 0 ] ; then
		printf "(%s seconds)" $secs
	fi
	echo " ####${color_reset}"
	echo
	return $ret
}

FA_RunCmd() {
	[ "$V" = "1" ] && echo "+ ${@}"
	eval $@ || exit $?
}

function usage()
{
	echo "Usage: $0 [ARGS]"
	echo
	echo "Options:"
	echo "  -a         build Android"
	echo "  -B         build U-Boot"
	echo "  -K         build Linux kernel"
	echo "  -W         build Wi-Fi drivers (.ko)"
	echo
	echo "  -F, --all  build all (U-Boot, kernel, wifi, Android)"
	echo "  -M         make rockdev image"
	echo "  -u         generate update.img"
	echo
	echo "  -h         show this help message and exit"
	exit 1
}

function parse_args()
{
	[ -z "$1" ] && usage;
	TEMP=`getopt -o "aBKWFMuh" --long "all" -n "$SELF" -- "$@"`
	if [ $? != 0 ] ; then exit 1; fi
	eval set -- "$TEMP"

	while true; do
		case "$1" in
			-a ) BUILD_ANDROID=true;    shift 1;;
			-B ) BUILD_UBOOT=true;      shift 1;;
			-K ) BUILD_KERNEL=true;     shift 1;;
			-W ) BUILD_WIFI=true;       shift 1;;
			-F|--all)
				 BUILD_UBOOT=true;
				 BUILD_KERNEL=true;
				 BUILD_ANDROID=true;
				 shift 1;;
			-M ) MAKE_RKDEV_IMG=true;   shift 1;;
			-u ) GEN_UPDATE_IMG=true;   shift 1;;

			-h ) usage; exit 1 ;;
			-- ) shift; break  ;;
			*  ) echo "invalid option $1"; usage; return 1 ;;
		esac
	done
}

#----------------------------------------------------------
function build_uboot() {
	(cd ${UBOOT_DIR} && {
		FA_RunCmd ${MAKE} ${UBOOT_CFG}
		FA_RunCmd ${MAKE} ARCHV=aarch64
		ret=$?
		FA_ShowTime $ret
	})
}

function build_kernel() {
	(cd ${KERNEL_DIR} && {
		FA_RunCmd ${MAKE} ARCH=arm64 ${KERNEL_CFG}
		FA_RunCmd ${MAKE} ARCH=arm64 ${KERNEL_IMG}
		ret=$?
		FA_ShowTime $ret
	})
}

function build_wifi() {
	echo "start build wifi driver ko"
	if [ -f "device/rockchip/common/build_wifi_ko.sh" ]; then
		source device/rockchip/common/build_wifi_ko.sh
	fi
}

function build_android() {
	source build/envsetup.sh

	FA_RunCmd lunch ${PRODUCT}-${VARIANT}
	FA_RunCmd ${MAKE} $*
}

function make_rockdev_img() {
	if [ -z ${TARGET_PRODUCT} ]; then
		source build/envsetup.sh >/dev/null
		FA_RunCmd lunch ${PRODUCT}-${VARIANT}
	fi

	FA_RunCmd ./mkimage.sh
	ret=$?
	FA_ShowTime $ret
}

function gen_update_img() {
	echo "generate update.img"
	local PACK_TOOL_DIR=RKTools/linux/Linux_Pack_Firmware
	local IMAGE_PATH=rockdev/Image-${PRODUCT}
	local UPDATE_GEN=rockdev/update_gen

	[ -d ${IMAGE_PATH} ] || make_rockdev_img
	[ -f ${IMAGE_PATH}/update.img ] && rm -vf ${IMAGE_PATH}/update.img

	mkdir -p $PACK_TOOL_DIR/rockdev/Image/
	FA_RunCmd "cp ${IMAGE_PATH}/* $PACK_TOOL_DIR/rockdev/Image/ -f"

	cd $PACK_TOOL_DIR/rockdev && {
		./mkupdate.sh
		ret=$?
		FA_ShowTime $ret
		cd - >/null
	}

	mv $PACK_TOOL_DIR/rockdev/update.img $IMAGE_PATH/
	rm $PACK_TOOL_DIR/rockdev/Image -rf
}

#----------------------------------------------------------

parse_args $@

[ "$BUILD_UBOOT"    = true ] && build_uboot
[ "$BUILD_KERNEL"   = true ] && build_kernel
[ "$BUILD_WIFI"     = true ] && build_wifi
[ "$BUILD_ANDROID"  = true ] && build_android
[ "$MAKE_RKDEV_IMG" = true ] && make_rockdev_img
[ "$GEN_UPDATE_IMG" = true ] && gen_update_img

