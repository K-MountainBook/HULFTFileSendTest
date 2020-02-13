#!/bin/sh

############################################
# シェルスクリプト名称：SendFileTest.sh
# シェルスクリプト機能：HULFTループバックテスト用
# シェルスクリプト起動引数: ①コピー元テストデータファイル名(拡張子省略/.dat限定)
#                           ②コピー先テストファイルID
#                           ②対象処理出力ファイルID
#                           ②処理完了待機時間
#                           ②処理対象面
# シェルスクリプト終了ステータス：  0：正常終了
# シェルスクリプト機能概要：元データをコピーしてRファイルをsendしてトークンデトークンして、Sファイルsendしてreciveに入ったSファイルを消すを自動で行う。
#
# バージョン    作成日      作成者          更新履歴
# Ver1.00      2020/02/13   K.Yamamoto        新規作成
############################################

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
