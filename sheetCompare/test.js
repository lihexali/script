/**
 * Created by lihex on 5/9/17.
 */
var path = require('path');
var fs = require('fs');
var xlsx = require("xlsx");


var checkArrDataDiff = function(existArrs, dataArr){
    if(!existArrs.length) return true;
    var isSame = true;
    for (var i = 0; i < existArrs.length; i++) {
        var arr = existArrs[i];
        for (var j = 2; j < arr.length; j++) { //跳过行号
            if(arr[j] != dataArr[j]) {
                isSame = false;
                break;
            }
        }
    }
    return !isSame;
}

var valueEquals = function(v1, v2){
    v1 = v1 == "NULL" ? null : v1;
    v2 = v2 == "NULL" ? null : v2;
    if(!v1 || !v2) return v1 == v2;
    return v1.toString().trim() == v2.toString().trim();
}

var parse = function(xlsxName){
    var xlsxPath = path.join(__dirname, xlsxName);
    var workbook = xlsx.readFile(xlsxPath);
    var sheetName = workbook.SheetNames[0];
    var sheet = workbook.Sheets[sheetName];
    console.log(xlsxName + "\r\n");
    //console.log(sheet);


    var SheetKeys = Object.keys(sheet);
    SheetKeys = SheetKeys.filter(function(v){
        return v != '!ref' && v != '!merges'
    });
    //console.log(SheetKeys);

    var getColName = function(colKey){
        return colKey.match(/^[A-Za-z]+/)[0];
    }

    var getColRow = function(colKey){
        return parseInt(colKey.match(/\d+$/)[0]);
    }

//console.log(getColName('A4'), getColRow('B4'));

    var getTitlePos =function(keyWord){
        for (var i = 0; i < SheetKeys.length; i++) {
            var key = SheetKeys[i];
            if(sheet[key].v == keyWord) return key;
        }
        return -1;
    }

    var accountStartPos = getTitlePos('账号');
    var accountNameStartPos = getTitlePos('户名');
    var legalPersionNameStartPos = getTitlePos('法人');
    var licenseStartPos = getTitlePos('营业执照');
    var checkLicenseNoStartPos = getTitlePos('核准开户许可证号');
    //console.log(accountStartPos, accountNameStartPos, legalPersionNameStartPos)


    var ref = sheet['!ref'];
    var sheetRange = ref.split(':');
    var maxRows = getColRow(sheetRange[1]);
    //console.log(maxRows);

    var InfoMapAccount ={
        /*
         账号1: [
         [
         账号
         , 法人1
         , 户名1
         , 营业执照
         , 核准开户许可证号
         ],
         [
         账号
         , 法人2
         , 户民2
         , 营业执照
         , 核准开户许可证号
         ]
         ],
         ...
         }*/
    }

    var InfoMapLegalName ={
        /*
         法人1: [
         [
         账号
         , 户名1
         , 法人1
         , 营业执照
         , 核准开户许可证号
         ],
         [
         账号
         , 户名2
         , 法人2
         , 营业执照
         , 核准开户许可证号
         ]
         ],
         ...
         }*/
    }



    var startRow = parseInt(getColRow(accountStartPos));
    for (var i = startRow + 1; i <= maxRows; i++) {
        //console.log("i=", i);
        var accountKey = getColName(accountStartPos) + i;
        var accountNameKey = getColName(accountNameStartPos) + i;
        var legalPersionNameKey = getColName(legalPersionNameStartPos) + i;
        var licenseKey = getColName(licenseStartPos) + i;
        var checkLicenseNoKey = getColName(checkLicenseNoStartPos) + i;

        var accountBlock = sheet[accountKey];
        if(!accountBlock)continue;

        var accountNameBlock = sheet[accountNameKey] || {};
        var legalPersionBlock = sheet[legalPersionNameKey] || {};
        var licenseBlock = sheet[licenseKey] || {};
        var checkLicenseNoBlock = sheet[checkLicenseNoKey] || {};

        var account = accountBlock.v;
        var accountName = accountNameBlock.v;
        var legalPersionName = legalPersionBlock.v;
        var license = licenseBlock.v;
        var checkLicenseNo = checkLicenseNoBlock.v;
        var dataList = InfoMapAccount[account] = InfoMapAccount[account] || [];

        var dataArr = [
            xlsxName,
            accountKey,
            account,
            accountName,
            legalPersionName,
            license,
            checkLicenseNo,
        ];
        if(checkArrDataDiff(dataList, dataArr)){
            dataList.push(dataArr);
        }

        var dataList = InfoMapLegalName[legalPersionName] = InfoMapLegalName[legalPersionName] || [];
        var dataArr = [
            xlsxName,
            accountKey,
            account,
            accountName,
            legalPersionName,
            license,
            checkLicenseNo,
        ];
        if(checkArrDataDiff(dataList, dataArr)){
            dataList.push(dataArr);
        }

    }

    //console.log(JSON.stringify(InfoMapAccount));
    //console.log(JSON.stringify(InfoMapLegalName));

    return [InfoMapAccount, InfoMapLegalName];
}
var checkInside = function(infoMapAccount, infoMapLegalName){
    for (var account in infoMapAccount) {
        var dataList = infoMapAccount[account];
        if(dataList.length > 1){
            var strArgs = [
                "账号", account, "同一张表对应",
            ];
            var poses = [];
            for (var i = 0; i < dataList.length; i++) {
                var data = dataList[i];
                poses.push(data[1]);
            }
            poses.sort();
            strArgs = strArgs.concat(poses);
            strArgs = strArgs.concat([dataList.length, "条不同信息", "\r\n"]);
            console.log.apply(console,strArgs)
        }
    }

    for (var legalPersonName in infoMapLegalName) {
        var dataList = infoMapLegalName[legalPersonName];
        if(dataList.length > 1){
            var strArgs = [
                "法人", legalPersonName, "同一张表对应",
            ];
            var poses = [];
            for (var i = 0; i < dataList.length; i++) {
                var data = dataList[i];
                poses.push(data[1]);
            }
            poses.sort();
            strArgs = strArgs.concat(poses);
            strArgs = strArgs.concat([dataList.length, "条不同信息", "\r\n"]);
            console.log.apply(console,strArgs)
        }
    }
}

var testAXLSX='test1.xlsx';
var testBXLSX='test2.xlsx';
if(!fs.existsSync(testAXLSX) || !fs.existsSync(testBXLSX)){
    console.log("错误：请确脚本同目录下有", testAXLSX, "和", testBXLSX);
    console.log("\r\n");
    return;
}
console.log("将对比这些信息：账号 户名 法人 营业执照 核准开户许可证号");
console.log("\r\n");

console.log("-->单表检查:" + "\r\n");
var retArrTest1 = parse(testAXLSX);
checkInside(retArrTest1[0], retArrTest1[1]);

console.log("\r\n");
var retArrTest2 = parse(testBXLSX);
checkInside(retArrTest2[0], retArrTest2[1]);

var checkBoth = function(map1, map2, typeName){
    for (var account in map1) {
        if(!map2[account]) continue;
        var dataList1 = map1[account];
        var dataList2 = map2[account];

        dataList2 = dataList2.filter(function(d){
            return checkArrDataDiff(dataList1, d);
        })

        for (var i = 0; i < dataList1.length; i++) {
            var data1 = dataList1[i];
            for (var j = 0; j < dataList2.length; j++) {
                var data2 = dataList2[j];
                var strArr = [
                    data1[0], data1[1]
                    , "与"
                    , data2[0], data2[1]
                    ,typeName, account, "相同"
                    , ",其他数据存在不同:"
                    , "\r\n"
                ];

                var difArr = [];
                for (var k = 2; k < data1.length; k++) { //偏移两个元素
                    var info1 = data1[k];
                    var info2 = data2[k];
                    if(!valueEquals(info1, info2)){
                        var logArgs=[
                                info1
                                ,"不同于"
                                ,info2
                                ,"\r\n"
                        ];
                        if(!difArr.length){
                            console.log.apply(console, strArr);
                        }
                        console.log.apply(console, logArgs);
                        difArr.push(logArgs);
                    }
                }
                console.log("\r\n");
            }
        }
    }
}

console.log("\r\n");
console.log("-->双表检查:" + "\r\n" );
checkBoth(retArrTest1[0], retArrTest2[0], "账号");
checkBoth(retArrTest1[1], retArrTest2[1], "法人");


