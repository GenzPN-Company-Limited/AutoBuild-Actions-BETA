# OpenWrt-Actions & One-key AutoUpdate

Stable repository for AutoBuild-Actions: [AutoBuild-Actions-Template](https://github.com/Hyy2001X/AutoBuild-Actions-Template)

Customized package repository: [AutoBuild-Packages](https://github.com/Hyy2001X/AutoBuild-Packages)

Supported OpenWrt sources: `coolsnowwolf/lede`, `immortalwrt/immortalwrt`, `openwrt/openwrt`, `lienol/openwrt`, `padavanonly/immortalwrtARM`, `hanwckf/immortalwrt-mt798x`

## Maintenance Device List

| Maintained | Model | Configuration File (TARGET_PROFILE) | Source | Note |
| :----: | :----: | :----: | :----: | :----: |
| ✅ | [x86_64](./.github/workflows/AutoBuild-x86_64.yml) | [x86_64](./Configs/x86_64) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [Newifi 3](./.github/workflows/AutoBuild-d-team_newifi-d2.yml) | [d-team_newifi-d2](./Configs/d-team_newifi-d2) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [ASUS ACRH17](./.github/workflows/AutoBuild-asus_rt-ac42u.yml) | [asus_rt-ac42u](./Configs/asus_rt-ac42u) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [Phicomm N1](./.github/workflows/AutoBuild-p2w_r619ac-128m.yml) | [p2w_r619ac-128m](./Configs/p2w_r619ac-128m) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [Xiaoyu C5](./.github/workflows/AutoBuild-xiaoyu_xy-c5.yml) | [xiaoyu_xy-c5](./Configs/xiaoyu_xy-c5) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [Redmi AC2100](./.github/workflows/AutoBuild-xiaomi_redmi-router-ac2100.yml) | [xiaomi_redmi-router-ac2100](./Configs/xiaomi_redmi-router-ac2100) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ❎ | [Redmi AX6S](./.github/workflows/AutoBuild-xiaomi_redmi-router-ax6s.yml) | [xiaomi_redmi-router-ax6s](./Configs/xiaomi_redmi-router-ax6s) | [lede](https://github.com/coolsnowwolf/lede) |  |
| ✅ | [China Mobile RAX3000M](./.github/workflows/AutoBuild-cmcc_rax3000m.yml) | [cmcc_rax3000m](./Configs/cmcc_rax3000m) | [immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) |  |
| ✅ | [JCG Q30](./.github/workflows/AutoBuild-jcg_q30.yml) | [jcg_q30](./Configs/jcg_q30) | [immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) |  |

🔔 **For your account safety, please do not use SSH to connect to Github Actions**, `.config` configuration and firmware customization should be done locally 🔔

🎈 **Note**: The **TARGET_PROFILE** in the document is the name (code) of the device being compiled, such as `d-team_newifi-d2`, `asus_rt-acrh17`, `x86_64`.

**TARGET_PROFILE** can be obtained locally as follows:

① Run `make menuconfig`, select the device, save and exit

② Execute `egrep -o "CONFIG_TARGET.*DEVICE.*=y" .config | sed -r 's/.*DEVICE_(.*)=y/\1/'` in the source directory

Or `grep 'TARGET_PROFILE' .config` to get the **TARGET_PROFILE**

## I. Customize Firmware (Optional)

1. **Fork** this repository, and go to your own `AutoBuild-Actions` repository, **all operations below will be performed under your `AutoBuild-Actions` repository**, you can **Clone** it locally to operate

   It is recommended to use `Github Desktop` or `Notepad--` for editing and submission operations [[Github Desktop](https://desktop.github.com/)] [[Notepad--](https://notepad-plus-plus.org/downloads/) ([https://gitee.com/cxasm/notepad--/releases/tag/v2.11)]

2. Edit the configuration files in the `Configs` directory, the naming of the configuration files is generally **TARGET_PROFILE**, if the configuration file does not exist, it needs to be generated locally and uploaded

3. Edit the `.github/workflows/***.yml` file, modify `line 7 name:`, and fill in an easily recognizable name `e.g. NEWIFI D2`

4. Edit the `.github/workflows/***.yml` file, modify `line 32 CONFIG_FILE:`, and fill in the configuration name you added to the `Configs` directory

5. Edit [Scripts/AutoBuild_DiyScript.sh](./Scripts/AutoBuild_DiyScript.sh) as needed

Add software packages and other customization options in the `Firmware_Diy()` function, other files in the `Scripts` directory do not need to be modified

**Variables in the Scripts/AutoBuild_DiyScript.sh: Firmware_Diy_Core() function:**
```
   Author: Name of the author, AUTO: [Auto-detect]
   
   Author_URL: Custom author website or domain, AUTO: [Auto-detect]

   Default_Flag: Firmware tag (name suffix), suitable for different configuration files, AUTO: [Auto-detect]

   Default_IP: Firmware IP address

   Default_Title: Additional information displayed on the homepage of the terminal

   Short_Fw_Date: Shortened firmware date, true: [20210601]; false: [202106012359]

   x86_Full_Images: Upload detected x86 virtual disk images, true: [Upload]; false: [Do not upload]
   
   Fw_MFormat: Custom firmware format, AUTO: [Auto-detect]

   Regex_Skip: Discard files containing this content when outputting firmware

   AutoBuild_Features: Automatically add AutoBuild firmware features, recommended to enable

   Note: To disable a feature, change the variable value to false, to enable it set it to true

```

## II. Compile Firmware

   **Manual Compilation**: Click the `Actions` option in the toolbar above, select the device on the left, click `Run workflow` on the right, then click the `green button` to start compiling

   **Star One-Click Compilation**: Edit the `.github/workflows/***.yml` file, remove the comment `#` symbol, and submit the modification. Click or double-click to highlight the **Star** ⭐ button in the upper right corner to compile with one click

```
  #watch:
  #  types: [started]
```
   **Scheduled Compilation**: Edit the `.github/workflows/***.yml` file, remove the comment `#` symbol, modify the time as needed, and submit the modification [Cron usage](https://www.runoob.com/w3cnote/linux-crontab-tasks.html)
```
  #schedule:
  #  - cron: 0 8 * * 5
```
   **Temporarily Change Firmware IP Address**: This feature only works for **manual compilation**. After clicking `Run workflow`, you can enter the IP address

   **Use Other [.config] Configuration Files**: After clicking `Run workflow`, you can choose the configuration file name under the `Configs` directory

## III. Deploy Cloud Log (Optional)

1. Download the [Update_Logs.json](https://github.com/Hyy2001X/AutoBuild-Actions/releases/download/AutoUpdate/Update_Logs.json) from this repository to your local machine (if available)

2. Edit the local `Update_Logs.json` in **JSON** format

3. Manually upload the modified `Update_Logs.json` to `Github Release`

4. Execute `autoupdate --fw-log` locally for testing

## Use One-Key Update Firmware Script (Optional)

   First, open the `TTYD terminal` or use `SSH`, and enter the following commands as needed:

   Update firmware: `autoupdate`

   Use mirror to accelerate firmware update: `autoupdate -P`

   Update firmware (without saving configuration): `autoupdate -n`
   
   Force flash firmware (dangerous): `autoupdate -F`
   
   Force download and flash firmware: `autoupdate -f`

   Update script: `autoupdate -x`
   
   Print operation log: `autoupdate --log`

   View script help: `autoupdate --help`

## Acknowledgments

   - [Lean's Openwrt Source code](https://github.com/coolsnowwolf/lede)

   - [P3TERX's

 Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)

   - [CTCGFW's OpenWrt](https://github.com/project-openwrt/openwrt)

   - [Lucifer's Actions-Lean-OpenWrt](https://github.com/Lienol/openwrt)

   - [SuLingGG's OpenWrt-Rpi](https://github.com/SuLingGG/OpenWrt-Rpi)

   - [nanych's ImmortalWrtARM](https://github.com/nanych/immortalwrtARM)

   - [Sirpdboy's Openwrt18.06](https://github.com/sirpdboy/sirpdboy-package)
