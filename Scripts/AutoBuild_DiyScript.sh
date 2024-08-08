#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions-BETA>
# AutoBuild DiyScript

Firmware_Diy_Core() {

    # Modify variables in this function as needed, use the case statement to control different preset variable settings

    # Available preset variables
    # ${OP_AUTHOR}          OpenWrt source code author
    # ${OP_REPO}            OpenWrt repository name
    # ${OP_BRANCH}          OpenWrt source code branch
    # ${CONFIG_FILE}        Configuration file

    Author=AUTO
    # Author name, AUTO: [Automatically recognized]

    Author_URL=AUTO
    # Custom author website or domain, AUTO: [Automatically recognized]

    Default_Flag=AUTO
    # Firmware tag (name suffix), suitable for different configuration files, AUTO: [Automatically recognized]

    Default_IP="192.168.1.1"
    # Firmware IP address

    Default_Title="Powered by AutoBuild-Actions"
    # Additional information displayed on the firmware terminal homepage

    Short_Fw_Date=true
    # Short firmware date, true: [20210601]; false: [202106012359]

    x86_Full_Images=false
    # Upload detected x86 virtual disk images, true: [Upload]; false: [Do not upload]

    Fw_MFormat=AUTO
    # Custom firmware format, AUTO: [Automatically recognized]

    Regex_Skip="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory|itb|profile|ext4|json"
    # Discard firmware/files containing this content when outputting firmware

    AutoBuild_Features=true
    # Add AutoBuild firmware features, true: [Enable]; false: [Disable]

    AutoBuild_Features_Patch=false
    AutoBuild_Features_Kconfig=false
}

Firmware_Diy() {

    # Customize firmware in this function

    # Available preset variables, other available variables please refer to the run log
    # ${OP_AUTHOR}          OpenWrt source code author
    # ${OP_REPO}            OpenWrt repository name
    # ${OP_BRANCH}          OpenWrt source code branch
    # ${TARGET_PROFILE}     Device name
    # ${TARGET_BOARD}       Device architecture
    # ${TARGET_FLAG}        Firmware name suffix
    # ${CONFIG_FILE}        Configuration file

    # ${CustomFiles}        Absolute path of /CustomFiles in the repository
    # ${Scripts}            Absolute path of /Scripts in the repository

    # ${WORK}               OpenWrt source directory
    # ${FEEDS_CONF}         feeds.conf.default file in the OpenWrt source directory
    # ${FEEDS_LUCI}         package/feeds/luci directory in the OpenWrt source directory
    # ${FEEDS_PKG}          package/feeds/packages directory in the OpenWrt source directory
    # ${BASE_FILES}         package/base-files/files directory in the OpenWrt source directory

    # AddPackage <package_path> <git_user> <git_repo> <git_branch>
    # ClashDL <platform> <core_type> [dev/tun/meta]
    # ReleaseDL <release_url> <file> <target_path>
    # Copy <cp_from> <cp_to > <rename>
    # merge_package <git_branch> <git_repo_url> <package_path> <target_path>..

    case "${OP_AUTHOR}/${OP_REPO}:${OP_BRANCH}" in
    coolsnowwolf/lede:master)
        cat >> ${Version_File} <<EOF
sed -i '/check_signature/d' /etc/opkg.conf
if [ -z "\$(grep "REDIRECT --to-ports 53" /etc/firewall.user 2> /dev/null)" ]
then
    echo '# iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
    echo '# iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
    echo '# [ -n "\$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
    echo '# [ -n "\$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
    echo 'iptables -t mangle -A PREROUTING -i pppoe -p icmp --icmp-type destination-unreachable -j DROP' >> /etc/firewall.user
    echo 'iptables -t mangle -A PREROUTING -i pppoe -p tcp -m tcp --tcp-flags ACK,RST RST -j DROP' >> /etc/firewall.user
    echo 'iptables -t mangle -A PREROUTING -i pppoe -p tcp -m tcp --tcp-flags PSH,FIN PSH,FIN -j DROP' >> /etc/firewall.user
    echo '[ -n "\$(command -v ip6tables)" ] && ip6tables -t mangle -A PREROUTING -i pppoe -p tcp -m tcp --tcp-flags PSH,FIN PSH,FIN -j DROP' >> /etc/firewall.user
    echo '[ -n "\$(command -v ip6tables)" ] && ip6tables -t mangle -A PREROUTING -i pppoe -p ipv6-icmp --icmpv6-type destination-unreachable -j DROP' >> /etc/firewall.user
    echo '[ -n "\$(command -v ip6tables)" ] && ip6tables -t mangle -A PREROUTING -i pppoe -p tcp -m tcp --tcp-flags ACK,RST RST -j DROP' >> /etc/firewall.user
fi
exit 0
EOF
        # sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${FEEDS_PKG}/ttyd/files/ttyd.config
        # sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
        # sed -i '/uci commit luci/i\uci set luci.main.mediaurlbase="/luci-static/argon-mod"' $(PKG_Finder d package default-settings)/files/zzz-default-settings

        rm -r ${FEEDS_LUCI}/luci-theme-argon*
        AddPackage other vernesong OpenClash dev
        AddPackage other jerrykuku luci-app-argon-config master
        AddPackage other fw876 helloworld main
        AddPackage other sbwml luci-app-mosdns v5
        AddPackage themes jerrykuku luci-theme-argon 18.06
        AddPackage themes thinktip luci-theme-neobird main
        AddPackage msd_lite ximiTech luci-app-msd_lite main
        AddPackage msd_lite ximiTech msd_lite main
        AddPackage iptvhelper riverscn openwrt-iptvhelper master
        rm -r ${WORK}/package/other/helloworld/mosdns
        rm -r ${FEEDS_PKG}/mosdns
        rm -r ${FEEDS_LUCI}/luci-app-mosdns
        rm -r ${FEEDS_PKG}/curl
        rm -r ${FEEDS_PKG}/msd_lite
        Copy ${CustomFiles}/curl ${FEEDS_PKG}
        
        case "${TARGET_BOARD}" in
        ramips)
            sed -i "/DEVICE_COMPAT_VERSION := 1.1/d" target/linux/ramips/image/mt7621.mk
            Copy ${CustomFiles}/Depends/automount $(PKG_Finder d "package" automount)/files 15-automount
        ;;
        esac

        case "${CONFIG_FILE}" in
        d-team_newifi-d2-Clash | xiaoyu_xy-c5-Clash)
            ClashDL mipsle-hardfloat tun
        ;;
        esac
            
        case "${TARGET_PROFILE}" in
        d-team_newifi-d2)
            Copy ${CustomFiles}/${TARGET_PROFILE}_system ${BASE_FILES}/etc/config system
        ;;
        x86_64)
            # sed -i "s?6.1?6.6?g" ${WORK}/target/linux/x86/Makefile
            ClashDL amd64 dev
            ClashDL amd64 tun
            ClashDL amd64 meta
            AddPackage passwall xiaorouji openwrt-passwall-packages main
            AddPackage passwall xiaorouji openwrt-passwall main
            # AddPackage passwall xiaorouji openwrt-passwall2 main
            rm -r ${WORK}/package/other/helloworld/xray-core
            rm -r ${WORK}/package/other/helloworld/xray-plugin
            # rm -rf packages/lean/autocore
            # AddPackage lean Hyy2001X autocore-modify master
            Copy ${CustomFiles}/speedtest ${BASE_FILES}/usr/bin
            chmod +x ${BASE_FILES}/usr/bin/speedtest
        ;;
        xiaomi_redmi-router-ax6s)
            ClashDL armv8 dev
            ClashDL armv8 tun
            ClashDL armv8 meta
            # Copy ${CustomFiles}/${TARGET_PROFILE}_network ${BASE_FILES}/etc/config network
            AddPackage kernel xanmod ax210 ax210-master
            AddPackage kernel xanmod ax206 ax210-master
            AddPackage kernel xanmod ax200 ax210-master
        ;;
        esac
    ;;
    esac
}
