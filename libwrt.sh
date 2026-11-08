#!/bin/sh
# 放在仓库根目录，替换原来的 libwrt.sh（workflow 里 DIY_SCRIPT: libwrt.sh）
# 所有命令都在 openwrt/ 源码目录下执行

# ---------- 1. athena-led（原仓库逻辑，保留） ----------
rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# ---------- 2. iStore 软件中心 ----------
grep -q 'src-git istore' feeds.conf.default || \
  echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default

# ---------- 3. AdGuardHome（只取 kenzok8 仓库里的这一个包） ----------
rm -rf /tmp/kenzok8 package/luci-app-adguardhome
git clone --depth=1 --filter=blob:none --sparse https://github.com/kenzok8/openwrt-packages /tmp/kenzok8
( cd /tmp/kenzok8 && git sparse-checkout set luci-app-adguardhome )
cp -r /tmp/kenzok8/luci-app-adguardhome package/

# ---------- 4. 雷神加速器（leigod-acc 主包 + luci-app-leigod-acc 界面） ----------
rm -rf package/luci-app-leigod-acc
git clone --depth=1 https://github.com/miaoermua/luci-app-leigod-acc package/luci-app-leigod-acc

# ---------- 5. 重新索引 feeds ----------
./scripts/feeds update -a
./scripts/feeds install -a
