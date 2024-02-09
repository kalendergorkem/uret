#!/bin/bash

while true; do
    # Birinci Komut Başlasın
    rm -r chia-plotter/build/tmp/*
	cd /root/chia-plotter/build
    ./chia_plot -n 1 -r 32 -u 256 -t tmp/ -d final/ -f a7d66ae4efb383e0ed6c52ed064192ad14d7889f6880a02c2c88fb6b01110f8bcd7836ca807bb82a860c693a11e1d844 -c xch17kam40qfl5ukumzyj527jnpyddyzkxylrpfncz9qzevk5skwl4pqfkaq30

    # Birinci Komutun PID'sini al
    pid=$!

    # Birinci Komut Bitene Kadar Bekle
    wait $pid

    # İkinci Komut Başlasın
    cd /root/chia-plotter/build/final 
    for file in *.plot; do
      index=$((`rand -M 8800` + 1))
      counter=$((`rand -M 64` + 1))
        acc="a ($index).json"
        rclone move "$file" "drive$counter:" --user-agent="ISV|rclone.org|rclone/v1.61.0-beta.6610.beea4d511" --buffer-size=32M --drive-chunk-size=16M --drive-upload-cutoff=1000T --drive-pacer-min-sleep=700ms --checksum --check-first --drive-acknowledge-abuse --copy-links --drive-stop-on-upload-limit --no-traverse --tpslimit-burst=0 --retries=3 --low-level-retries=10 --checkers=14 --tpslimit=1 --transfers=7 --fast-list --drive-service-account-file "/root/accounts/$acc" -P

        # İkinci Komut Bitene Kadar Bekle
        wait $!
    done
done
