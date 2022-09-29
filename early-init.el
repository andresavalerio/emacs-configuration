;;; early-init.el --- Early initialization file for Emacs

;; Author: andresavalerio
;; Maintainer: andresavalerio


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:
;;; Emacs Startup File --- early initialization for Emacs

;;; Code:

;; Initial Config
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)
(save-place-mode 1)
(set-fringe-mode 10)

;; Cursor Config
(setq-default blink-cursor-blinks 0)
(setq-default blink-cursor-interval 0.5)
(setq-default blink-cursor-delay 0.5)
(blink-cursor-mode 1)
(global-hl-line-mode 1)

;; Variables
(setq-default tab-width 4)
(setq-default fill-column 80)
(setq-default require-final-newline 't)
(setq-default indent-tabs-mode nil)
(setq-default fringes-outside-margins t)

;; Parethesis
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Time
(setq-default display-time-default-load-average nil)
(display-time-mode 1)

;; Prevent package.el loading packages prior to init file loading
(setq-default package-enable-at-sturtup nil)

;; Configure use-package to use straight.el by default
(setq-default straight-use-package-by-default t)

;; Set Emacs directory
(setq-default user-emacs-directory "~/.config/emacs")

;; Silence compilation warnings
(setq-default native-comp-async-report-warnings-errors nil)

;; Revert Dired and other buffers
(setq-default global-auto-revert-non-file-buffers t)

;; Auto-update buffers on file change
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(setq auto-revert-use-notify t)
(setq auto-revert-interval 1)
(setq auto-revert-check-vc-info t)
(global-set-key (kbd "<f5>") 'revert-buffer)

(defvar my/default-font-size 120)
(defvar my/default-variable-font-size 120)

;; Keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key "\M-z" 'zap-up-to-char)
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-q") 'fill-paragraph)

(defun my/split-window-right ()
  "Split window with another buffer."
  (interactive)
  (select-window (split-window-right))
  (switch-to-buffer (other-buffer)))

(defun my/split-window-below ()
  "Split window with another buffer."
  (interactive)
  (select-window (split-window-below))
  (switch-to-buffer (other-buffer)))

(global-set-key (kbd "C-x 2") #'my/split-window-below)
(global-set-key (kbd "C-x 3") #'my/split-window-right)

;; Don't compact font caches during GC.
(setq-default inhibit-compacting-font-caches t)

;; Performance improvements for lsp
(setq-default gc-cons-threshold (* 100 1024 1024)) ;; 100 Mb
(setq-default read-process-output-max (* 4 1024 1024)) ;; 4 Mb

;; Don't auto-split vertically
(setq-default split-height-threshold nil)

;; Scroll compilation buffer until first error
(setq-default compilation-scroll-output 'first-error)

;; Change location of native compilation cache
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
	  (expand-file-name  "var/eln-cache/" user-emacs-directory))))
