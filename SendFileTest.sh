#!/bin/sh

SEND_DIR="/app/share/batch${5}/cts/batch/appdata/hulft/send"
RECV_DIR="/app/share/batch${5}/cts/batch/appdata/hulft/receive"

BASE_FILE="${SEND_DIR}/${1}.dat"
COPY_FILE="${SEND_DIR}/${2}.dat"

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

if [ ! -f "${RECV_DIR}/${3}.dat" ]; then
 echo "$(date) ${4}秒待ったけど${RECV_DIR}/${3}.datが出力されないので削除できない！！" >> "${SEND_DIR}/error.log"
else
# delete revice file
 rm -f "${RECV_DIR}/${3}.dat"
fi

# delete send file
rm -f ${SEND_DIR}/${2}.dat
rm -f ${SEND_DIR}/${3}.dat

### 終了
exit 0
