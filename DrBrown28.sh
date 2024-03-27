#!/usr/bin/bash

# Kernel Details
VER="-7.2"

# Vars
BASE_AK_VER="SCALPEL_By_DrBrown28-DD3BOH"
AK_VER="$BASE_AK_VER$VER"
export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
#export CONFIG=vendor/NX659J_defconfig
export CONFIG_BASE=vendor/kona-perf_defconfig
export CONFIG_DEVICE=vendor/nx659j.config
#export PATH=home/toolchains/proton-clang-13/bin:$PATH
export PATH=home/clang-19/bin:$PATH
#export PATH=home/toolchains/Clang-18.0.0-20231114/bin:$PATH

echo "#"
echo "# Menuconfig"
echo "#"

make O=out $CONFIG_BASE $CONFIG_DEVICE;
make O=out CC=clang AS=llvm-as NM=llvm-nm STRIP=llvm-strip OBJDUMP=llvm-objdump CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- menuconfig
cp -rf out/.config arch/arm64/configs/$CONFIG_BASE $CONFIG_DEVICE;

echo "#"
echo "# Compile Kernel"
echo "#"
make O=out CC=clang $CONFIG_BASE $CONFIG_DEVICE;
time make -j$(nproc --all) O=out CC=clang AS=llvm-as NM=llvm-nm STRIP=llvm-strip OBJDUMP=llvm-objdump CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
echo -e "\033[1;36mPress enter to continue \e[0m"
read a1

# Make a dtb file
cd out/arch/arm64/boot/
find dts/vendor/qcom -name '*.dtb' -exec cat {} + > dtb
ls -a

echo "#"
echo "# Zipping into a flashable zip!"
echo "#"
cp out/arch/arm64/boot/Image.gz ~/AnyKernel3/
cp out/arch/arm64/boot/dtb ~/AnyKernel3/
cd ~/Anykernel3
zip -r9 Scalpel-Kernel-By-DrBrown28.zip *
cp Scalpel-Kernel-By-DrBrown28.zip ../$HOME
echo -e "\033[1;36mPress enter to continue \e[0m"
read a1

exit 0
