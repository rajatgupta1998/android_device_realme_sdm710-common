#!/system/bin/sh
#jie.cheng@swdp.shanghai, 2015/11/09, add init.oppo.hypnus.sh

function log2kernel()
{
    echo "hypnus: "$1 > /dev/kmsg
}

complete=`getprop sys.boot_completed`

if [ ! -n "$complete" ] ; then
     complete=0
fi

log2kernel "module insmod beging!"
#disable core_ctl
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/disable
n=0
while [ n -lt 3 ]; do
    #load data folder module if it is exist
    insmod /system/lib/modules/hypnus.ko -f boot_completed=$complete
    if [ $? != 0 ];then
n=$(($n+1));
log2kernel "Error: insmod hypnus.ko failed, retry: n=$n"
    else
log2kernel "module insmod succeed!"
break
    fi
done

if [ n -ge 3 ]; then
     log2kernel "Fail to insmod hypnus module!!"
fi

chown system:system /sys/kernel/hypnus/scene_info
chown system:system /sys/kernel/hypnus/action_info
chown system:system /sys/kernel/hypnus/view_info
chown system:system /sys/kernel/hypnus/notification_info
chown system:system /sys/kernel/hypnus/log_state
chown system:system /sys/kernel/hypnus/perfmode
chmod 0664 /sys/kernel/hypnus/notification_info
chmod 0664 /sys/kernel/hypnus/touch_boost
chown system:system /sys/kernel/hypnus/touch_boost
chown system:system /sys/kernel/hypnus/high_perfmode
chown system:system /sys/kernel/hypnus/reload_config
# 1 queuebuffer only; 2 queue and dequeuebuffer;
setprop persist.report.tid 2
chown system:system /data/hypnus
log2kernel "module insmod end!"
