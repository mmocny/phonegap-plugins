/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

/*
 * The W3C window.Notification API: http://www.w3.org/TR/notifications/
 */
if (typeof window.Notification == 'undefined') {

    /**
     * Creates and shows a new notification.
     * @param title
     * @param options
     */
    window.Notification = function(title, options) {
        options = options || {};

        this.title = title || 'defaultTitle';

        // w3c options:
        this.body = options.body || '';
        this.tag = options.tag || 'defaultTag';
        this.iconUrl = options.iconUrl || '';
        // titleDir, bodyDir are not supported

        // cordova option extensions:
        this.delay = options.delay || 0;
        this.soundUrl = options.soundUrl || '';
        this.badgeNumber = options.badgeNumber || 0;

        // there must be one unique notification per tag, so close any existing outstanting notifications
        if (window.Notification.active[this.tag])
            window.Notification.active[this.tag].close();
        window.Notification.active[this.tag] = this;

        // Spec claims these must be defined
        this.onclick = options.onclick;
        this.onerror = options.onerror;
        this.onclose = options.onclose;
        //this.onshow = options.onshow; // not supported

        var that = this;
        cordova.exec(function() {
            // Do not call onshow, since most notifications will be delayed showings anyway
            //if (that.onshow) {
            //    that.onshow();
            //}
        }, function(error) {
            if (that.onerror) {
                that.onerror(error);
            }
        }, 'WebNotifications', 'addNotification', [{
            tag: this.tag,
            title: this.title,
            body: this.body,
            delay: this.delay,
        }]);
    };

    window.Notification.permission = 'granted';

    window.Notification.requestPermission = function(callback) {
        setTimeout(function() {
            callback(window.Notification.permission);
        }, 0);
    };

    // Not part of the W3C API. Used by the native side to call onclick handlers.
    window.Notification.callOnclickByTag = function(tag) {
        var notification = window.Notification.active[tag];
        if (notification && notification.onclick && typeof notification.onclick == 'function') {
            notification.onclick(tag);
            delete window.Notification.active[tag];
        }
    };

    // A global map of notifications by tag, so their onclick callbacks can be called.
    window.Notification.active = {};

    /**
     * Cancels a notification that has already been created and shown to the user.
     */
    window.Notification.prototype.close = function() {
        var that = this;
        cordova.exec(function() {
            if (that.onclose) {
                console.log("inside");
                that.onclose();
            }
        }, function(error) {
            if (that.onerror) {
                that.onerror(error);
            }
        }, 'WebNotifications', 'cancelNotification', [{
            tag: this.tag,
        }]);
    };
}
