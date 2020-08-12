#!/bin/bash

# https://terraria.gamepedia.com/Server に書いてあるおまじない
# debian + ash の場合これ書かないとダメだった
export TERM=xterm

# stdio2session の状態をリセット
s2s-clean

# サーバーをバックグラウンドで起動
s2s-server /usr/bin/TerrariaServer.bin.x86_64 &
if [ $? -gt 0 ]; then
    exit 1
fi

# ワールド起動までのコマンドを流し込む
worlds=`find ~/.local/share/Terraria/Worlds/ | grep .wld`
if [ "$worlds" = "" ]; then

# ワールドが無い場合
s2s-write << EOF
n
1
1
default
114514
1
16
7777
y
hikehike
EOF

else

# ワールドがある場合
s2s-write << EOF
1
16
7777
y
hikehike
EOF

fi

# ログがでなくなるまで繰り返し読み出す
while ! `s2s-read`
do
    sleep 1
done

# 自動処理をスタート
crontab /etc/cron.d/terraria_server
service cron restart

# サーバーの終了を待機
echo Terraria server is ready!
wait

# 正常終了
exit 0
