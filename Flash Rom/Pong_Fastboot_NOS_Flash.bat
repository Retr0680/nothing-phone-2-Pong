@echo off
title Nothing Phone 2 Fastboot ROM Flasher (t.me/NothingPhone2)

echo ########################################################
echo #        Nothing Phone 2 Fastboot ROM Flasher V5       #
echo #               Developed And Tested By                #
echo #      Hellboy017, Ali Shahawez, Spike, Phatwalrus     #
echo #         [Nothing Phone (2) Telegram Dev Team]        #
echo #                Build Date:23/11/23                   #
echo ########################################################

echo ##########################
echo #  CHANGING ACTIVE SLOT  #
echo ##########################

set current_slot=null
choice /c ab /m "Select the slot you wish to flash the firmware to"
if %errorlevel% equ 1 (
    fastboot --set-active=a
    set current_slot=a
) else if %errorlevel% equ 2 (
    fastboot --set-active=b
    set current_slot=b
)
echo Active slot is slot %current_slot%

echo #######################
echo #   FORMATTING DATA   #
echo #######################

choice /m "Wipe Data?"
if %errorlevel% equ 1 (
    fastboot -w
)

echo  ##############################
echo  #   FLASHING BOOT/RECOVERY   #
echo  ##############################

for %%i in (boot vendor_boot dtbo recovery) do (
    fastboot flash %%i %%i.img
)

echo  ##########################             
echo  # REBOOTING TO FASTBOOTD #       
echo  ##########################

fastboot reboot fastboot

echo  #######################
echo  #  FLASHING FIRMWARE  #
echo  #######################

for %%i in (abl aop bluetooth cpucp devcfg dsp featenabler hyp imagefv keymaster modem multiimgoem multiimgqti qupfw qweslicstore shrm tz uefi uefisecapp xbl xbl_config xbl_ramdump) do (
    fastboot flash %%i %%i.img
)

echo #################################
echo #  RESIZING LOGICAL PARTITIONS  #
echo #################################

for %%i in (odm_a system_a system_ext_a product_a vendor_a vendor_dlkm_a odm_b system_b system_ext_b product_b vendor_b vendor_dlkm_b) do (
    fastboot delete-logical-partition %%i-cow
)
if %current_slot%==a (
    for %%i in (odm_a system_a system_ext_a product_a vendor_a vendor_dlkm_a) do (
        fastboot delete-logical-partition %%i
        fastboot create-logical-partition %%i 1
    )
) else if %current_slot%==b (
    for %%i in (odm_b system_b system_ext_b product_b vendor_b vendor_dlkm_b) do (
        fastboot delete-logical-partition %%i
        fastboot create-logical-partition %%i 1
    )
)

echo ###############################
echo # FLASHING LOGICAL PARTITIONS #
echo ###############################

for %%i in (system system_ext product vendor vendor_dlkm odm vbmeta vbmeta_system vbmeta_vendor) do (
    fastboot flash %%i %%i.img
)

echo ###############
echo #  REBOOTING  #
echo ###############

fastboot reboot

echo ##########################
echo # JOIN OUR TG COMMUNITY  #
echo ##########################

echo Feel free to join our Device Telegram Community by selecting an option below, or exit the script if you prefer (Use VPN if the links are not working):
echo ---------------------------------------------------
echo 1. Nothing Phone (2) Telegram Global Discussion
echo 2. Nothing Phone (2) Telegram Updates Channel
echo 3. Nothing Phone (2) Telegram Photography Group
echo 4. Join all of the above
echo 5. Exit
echo ---------------------------------------------------
set /p choice=Enter the number of your choice: 

if %choice% equ 1 start https://t.me/NothingPhone2
if %choice% equ 2 start https://t.me/NothingPhone2updates
if %choice% equ 3 start https://t.me/NothingPhone2Photography
if %choice% equ 4 (
    start https://t.me/NothingPhone2
    timeout /t 5 /nobreak >nul
    start https://t.me/NothingPhone2Updates
    timeout /t 5 /nobreak >nul
    start https://t.me/NothingPhone2Photography
)
if %choice% equ 5 exit /b

pause