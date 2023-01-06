;;; -*- coding: utf-8 -*-
;;; nu-fun.el --- 日本語編集用関数

;;; Copyright (C) 2015 Yoshihiko Kakutani

;;; Author: Yoshihiko Kakutani

;;; Copyright Notice:

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(defvar nu-my-toten "、"
  "バッファ内の標準読点。")
(defvar nu-my-kuten "。"
  "バッファ内の標準句点。")
(defvar nu-space-regexp "[ \t]")

(make-variable-buffer-local 'nu-my-toten)
(make-variable-buffer-local 'nu-my-kuten)

(defun nu-alternative-toten (toten)
  (if (string-equal toten "、") "，" "、"))

(defun nu-alternative-kuten (kuten)
  (if (string-equal kuten "。") "．" "。"))

(defun nu-toggle-my-kutoten ()
  "バッファの標準句読点を変更する。「、」と「，」、「。」と「．」の役割が入れ替わる。
他の句読点記号には対応していない。"
  (interactive)
  (setq nu-my-toten (nu-alternative-toten nu-my-toten))
  (setq nu-my-kuten (nu-alternative-kuten nu-my-kuten))
  (message "「%s%s」" nu-my-toten nu-my-kuten))

(defun nu-kutoten-buffer (&optional reverse)
  "バッファ内の句読点を全て標準句読点に変換する。
nilでない引数が与えられたときは、逆に、標準句読点を非標準句読点に変更する。"
  (interactive "P")
  (save-excursion
    (let ((toten (if reverse (nu-alternative-toten nu-my-toten) nu-my-toten))
          (kuten (if reverse (nu-alternative-kuten nu-my-kuten) nu-my-kuten))
          (comma (if reverse nu-my-toten (nu-alternative-toten nu-my-toten)))
          (period (if reverse nu-my-kuten (nu-alternative-kuten nu-my-kuten)))
          (case-fold-search nil))
      (goto-char (point-min))
      (while (search-forward comma nil t) (replace-match toten t t))
      (goto-char (point-min))
      (while (search-forward period nil t) (replace-match kuten t t))
      (message "「%s%s」 => 「%s%s」" comma period toten kuten))))

(defun nu-kutoten-region (from to &optional reverse)
  "リージョン内の句読点を全て標準句読点に変換する。
nilでない引数が与えられたときは、逆に、標準句読点を非標準句読点に変更する。"
  (interactive "r\nP")
  (save-restriction
    (narrow-to-region from to)
    (nu-kutoten-buffer reverse)))

(defun nu-eisuu-region (from to)
  "リージョン内の英数記号を全てASCII文字に変換する。"
  (interactive "r")
  (japanese-hankaku-region from to 'ascii))

(defun nu-unicode-region (from to)
  "リージョン内の各文字をUnicodeのコードポイントとして表現する。"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (while (< (point) (point-max))
        (insert (format "\\u%x" (encode-char (char-after) 'unicode)))
        (delete-char 1)))))

(defun nu-region-ascii-p (from to)
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (while (looking-at "[[:ascii:]]+$") (goto-char (match-end 0)))
      (= (point) (point-max)))))

(defun nu-multi-lines-to-one-line (from to)
  "複数行の文章を一行にまとめる。リージョンが対象。"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (let ((glue
             (if (nu-region-ascii-p from to) " " "")))
        (goto-char (point-min))
        (while (re-search-forward "[\n]" nil t)
          (unless (or (= (match-beginning 0) (point-min)) (= (point) (point-max)))
            (if (looking-at (concat nu-space-regexp "*" "[\n]"))
                (while (looking-at (concat nu-space-regexp "*" "[\n]"))
                  (goto-char (match-end 0)))
              (let ((match-info (match-data)))
                (if (looking-at (concat nu-space-regexp "+")) (replace-match "" t t))
                (set-match-data match-info)
                (replace-match glue t t)))))))))

(defun nu-one-line-to-multi-lines (from to)
  "一行の文章を句点で分割する。リージョンが対象。"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (let ((endmark-regexp
             (if (nu-region-ascii-p from to) "[.?!]" "[。．？！]")))
        (goto-char (point-min))
        (while (re-search-forward endmark-regexp nil t)
          (unless (= (point) (point-max))
            (if (looking-at "[\n]")
                (forward-char 1)
              (if (looking-at (concat nu-space-regexp "+")) (replace-match "" t t))
              (newline-and-indent))))))))

(provide 'nu-fun)
