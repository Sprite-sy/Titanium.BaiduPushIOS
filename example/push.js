//howto:
// put your BPushConfig.plist in you app/assets/iphone folder
// the usage is as following 

var _bdPush = null;
try {
    _bdPush = require("com.sprite.baidupush");
} catch (e) {

}
var Push = {
    start: function(e) {
        if (null == _bdPush) {
            return;
        }
        e = e || {};
        var key = e.key || "";
        var cbSuccess = e.success || null;
        var cbFail = e.fail || null;
        var cbNotify = e.notify || null;

        _bdPush.addEventListener("registered", function(e) {
            //_bdPush.bindChannel({});
        });

        _bdPush.addEventListener("bind", function(e) {
            _log("push bind");
            cbSuccess && cbSuccess.call(null, e);
        });

        _bdPush.addEventListener("notify", function(e) {
            _log("push bind");
            cbNotify && cbNotify.call(null, e);
        });

        _bdPush.addEventListener("registerFail", function(e) {
            _log("push registerFail");
            var ev = e;
            ev.type = "registerFail";
            cbFail && cbFail.call(null, ev);
        });
        //*
        setTimeout(function() {
            if (OS_ANDROID) {
                _bdPush.startWork("YOUR BAIDU APP KEY");
            }
        }, 2000); //*/
    },

    getInfo: function() {
        if (OS_IOS) {
            return _bdPush ? _bdPush.getInfo() : {
                err: "empty"
            };
        } else {
            return {};
        }
    },
    bind: function() {
        _bdPush && _bdPush.bindChannel({});
    },
    unbind: function() {
        _bdPush && _bdPush.unbindChannel({});
    },
};


exports.Push = Push;
