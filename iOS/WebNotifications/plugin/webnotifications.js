/*
 * The W3C standard API, window.Notification. See http://www.w3.org/TR/notifications/
 * This API should be used for new applications instead of the old plugin API above.
 */
if (typeof window.Notification == 'undefined') {

    /**
     * Creates and shows a new notification.
     * @param title
     * @param options
     */
    window.Notification = function(title, options) {
        options = options || {};

        // TODO: title must not be undefined
        this.title = title;
        this.body = options.body || '';
        this.tag = options.tag || 'defaultTag';

        // titleDir, bodyDir, iconUrl are not supported, perhaps we should issue console warnings

        if (window.Notification.active[this.tag])
            window.Notification.active[this.tag].close();
        window.Notification.active[this.tag] = this;

        // Spec claims these must be defined
        this.onclick = options.onclick;
        this.onerror = options.onerror;
        this.onshow = options.onshow;
        this.onclose = options.onclose;

        cordova.exec(function() {
            if (this.onshow) {
                this.onshow();
            }
        }, function(error) {
            if (this.onerror) {
                this.onerror(error);
            }
        }, 'StatusBarNotification', 'notify', [this.tag, this.title, this.body]);
    };

    // Permission is always granted on Android.
    window.Notification.permission = 'granted';

    window.Notification.requestPermission = function(callback) {
        callback('granted');
    };

    // Not part of the W3C API. Used by the native side to call onclick handlers.
    window.Notification.callOnclickByTag = function(tag) {
        console.log('callOnclickByTag');
        var notification = window.Notification.active[tag];
        if (notification && notification.onclick && typeof notification.onclick == 'function') {
            console.log('inside if');
            notification.onclick();
        }
    };

    // A global map of notifications by tag, so their onclick callbacks can be called.
    window.Notification.active = {};


    /**
     * Cancels a notification that has already been created and shown to the user.
     */
    window.Notification.prototype.close = function() {
        cordova.exec(function() {
            if (this.onclose) {
                this.onclose();
            }
        }, function(error) {
            if (this.onerror) {
                this.onerror(error);
            }
        }, 'StatusBarNotification', 'clear', [this.tag]);
    };
}
