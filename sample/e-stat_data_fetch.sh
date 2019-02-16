#!/bin/sh

echo "Please input your e-stat AppId:"
read APPID

rm ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv &&
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2&startPosition=1000001" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv &&
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2&startPosition=2000001" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv &&
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2&startPosition=3000001" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv &&
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2&startPosition=4000001" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv &&
curl "http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=$APPID&lang=J&statsDataId=0003105586&metaGetFlg=Y&cntGetFlg=N§ionHeaderFlg=2&startPosition=5000001" | \
tail -n +29 >> ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv

time ruby lib/adw_data_cleaner.rb ./test/sample_schema.sql ~/tmp/kourikakaku_`date +%Y%m%d`_all.csv