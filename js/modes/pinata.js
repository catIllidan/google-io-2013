goog.require('ww.mode.Core');
goog.provide('ww.mode.PinataMode');

/**
 * @constructor
 */
ww.mode.PinataMode = function() {
  goog.base(this, 'pinata', true);
};
goog.inherits(ww.mode.PinataMode, ww.mode.Core);

ww.mode.PinataMode.prototype.init = function() {
  goog.base(this, 'init');

  this.pinataEl = $('#pinata');
  this.stickEl = $('#pinata-stick');
  this.stickEl.addClass('whack-off');
};
