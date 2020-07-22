#!/bin/sh

if [ $# -ne 4 ]; then
    echo "実行するには4個の引数が必要です。" 1>&2
    echo "arg1:HULFTで集信したいファイル(arg2にリネームされます)" 1>&2
    echo "arg2:HULFT集信ファイルID(utlsendをするファイル)" 1>&2
    echo "arg3:処理後に出力されるHULFT配信ファイルID(arg2で受け取ったファイルを処理した後に出力されるファイル。すぐ消される)" 1>&2
    echo "arg4:arg3の出力を待つ時間(秒)" 1>&2
    echo "自動で何回も投入する場合は\"watch\"命令を使用してください。使い方はggr" 1>&2
    exit 1
fi

echo "ループバックの設定を行い、配信送信を連続で行うプログラムです。"
echo "ループバックの設定、及び必要なファイルの準備は完了していますか？"
echo "実行を行うHULFTサーバのSENDディレクトリ、RECIVEディレクトリをシェルスクリプト本体に記入しましたか？"

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

SEND_DIR="HULFTのSENDディレクトリ"
RECV_DIR="HULFTのRECIVEディレクトリ"

BASE_FILE="${SEND_DIR}/${1}"
COPY_FILE="${SEND_DIR}/${2}"

cp $BASE_FILE $COPY_FILE

if [ ! -f ${COPY_FILE} ]; then
    echo "$(date) ${COPY_FILE}がないよ" >> "${SEND_DIR}/error.log"
    exit 1
fi

utlsend -f ${2}

if [ $? != 0 ]; then
    echo "$(date) ${COPY_FILE}送信失敗！！" >> "${SEND_DIR}/error.log"
fi

sleep ${4}s

if [ ! -f "${RECV_DIR}/${3}" ]; then
    echo "$(date) ${4}秒待ったけど${RECV_DIR}/${3}.datが出力されないので削除できない！！" >> "${SEND_DIR}/error.log"
else
# delete revice file
    rm -f "${RECV_DIR}/${3}"
fi

# delete send file
rm -f ${SEND_DIR}/${2}.dat
rm -f ${SEND_DIR}/${3}.dat

### 終了
exit 0
