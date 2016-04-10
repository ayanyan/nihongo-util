;;; -*- coding: utf-8 -*-

(require 'nu-fun)

(setq-default nu-my-toten "、"
              nu-my-kuten "。")

(global-set-key "\C-cJ" 'nu-kutoten-buffer)
(global-set-key "\C-c1" 'nu-multi-lines-to-one-line)
(global-set-key "\C-c0" 'nu-one-line-to-multi-lines)
