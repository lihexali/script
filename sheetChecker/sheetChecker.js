/**
 * Created by lihex on 16/8/31.
 */
var DEBUG=true;
var iconv = require('./iconv-lite')
var fs=require('fs');
var rawSheet = fs.readFile('./success.txt', function(err, data){
    if(err) throw err;
    var sheet = iconv.decode(new Buffer(data), 'GB2312');
    //console.log(sheet);
    var rowRegx = /.*?\r\n/g;
    var lines = sheet.match(rowRegx);
    var titleLine = lines[0].replace('\r\n','');
    var titles = titleLine.split('|');
    //console.log(titles);

    var logger = {
        debug: function(tag, str){
           if(!DEBUG) return;
            console.log('[' + tag + ']: ' + str + '\r\n');
        },
        log: function(tag, str){
            console.log('[' + tag + ']: ' + str + '\r\n');
        },
        error: function(tag, str){
            console.error('[' + tag + ']: ' + str + '\r\n');
        }
    };

    var fixTotal = 0;
    var fieldCheckers = {};
    var registerChecker = function (fieldName, ckFun/*(filedName, oldValue, line)*/){
        var idx = titles.indexOf(fieldName);
        if(idx < 0) throw '不存在的字段名';
        fieldCheckers[idx] = ckFun;
    }
    var baseChecker = function(fieldName, field){
        if(field.length == 0){
            logger.debug('未设置',fieldName);
            return false;
        }
        return true;
    }
    registerChecker('发证机关', function(filedName, oldValue, line){
            var newVal = 5530;
            logger.debug('设置' + filedName, newVal);
            return newVal;
    });

    registerChecker('邮政编码', function(filedName, oldValue, line){
            var newVal = 411300;
            logger.debug('设置' + filedName, newVal);
            return newVal;
    });
    registerChecker('开户银行代码', function(filedName, oldValue, line){
            var newVal = 320553300025;
            logger.debug('设置' + filedName, newVal);
            return newVal;
    });

    function doLine(l){
        //logger.debug('修正前的', l);
        var fields = l.split('|');
        for(var j = 0, lj = fields.length; j < lj; j++){
            var fieldName = titles[j];
            var field = fields[j];
            baseChecker(fieldName, field);
            var checker = fieldCheckers[j];
            if(checker){
                var fixVal = checker(fieldName, field, l);
                if(fixVal){
                    fields[j] = fixVal;
                    fixTotal++;
                }
            }
        }
        var newLine = fields.join('|');
        return newLine;
    }
    var outStr = lines[0];
    for(var i = 1, li = lines.length; i < li; i++){
        logger.debug('正在修正', '第' + i + '行');
        var newLine = doLine(lines[i].replace('\r\n',''));
        //logger.debug('修正后的', newLine);
        outStr += newLine + '\r\n';
    }
    logger.log('修正完毕', "修正" + fixTotal + "条, 保存中...");
    fs.writeFile('out.txt', iconv.encode(outStr,'GB2312'), function(err){
        if(err){
            logger.error('保存', '失败');
            throw err;
        }
        logger.log('保存', '成功');
    })
});
