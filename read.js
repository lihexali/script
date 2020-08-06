/**
 * Created by lihex on 4/1/17.
 */
var fs = require('fs');
fs.readFile('./default.res.json', function (err, data) {
    var js = JSON.parse(data.toString());

    var groups = js.groups;
    var names = [];
    for (var i = 0, li = groups.length; i < li; i++) {
        var group = groups[i];
        var keys = group.keys;
        names = names.concat(keys.split(','))
    }
    for (var i = 0, li = names.length; i < li; i++) {
        var name = names[i];
        console.log(name);
    }
});