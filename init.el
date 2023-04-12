;;; init.el --- Initialization file for Emacs

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
;;; Emacs Startup File --- initialization for Emacs

;;; Code:

;; START PACKAGES N ORGANIZATION

;; Straight use-package
(setq-default straight-vc-git-default-clone-depth 1)
(setq-default straight-check-for-modifications '(check-on-save find-when-checking))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Keep Emacs directory clean
(use-package no-littering
  :demand t)

;; Saved customization location
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))

;; Store auto-save files under the var directory
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; Garbage Colector improvements
(use-package gcmh
  :demand t
  :config
  (gcmh-mode 1))

;; END PACKAGES N ORGANIZATION

;; START EMACS STYLE

;; Opening Recent Files list
(use-package recentf
  :config
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (recentf-mode 1))

;; Switch between buffers, files and directories with minimum keystrokes
(use-package ido
  :straight (:type built-in)
  :config
  (ido-mode t))

;; Encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; Font size
(set-face-attribute 'default nil :font "Fira Code" :height my/default-font-size)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :height my/default-font-size)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Fira Code" :height my/default-variable-font-size :weight 'regular)

;; Useless but cute ligatures display
(use-package ligature
  :straight (ligature :type git :host github :repo "mickeynp/ligature.el")
  :demand t
  :config
  ;; Global ligatures
  (ligature-set-ligatures 't '("www"))
  ;; Coding ligatures
  (ligature-set-ligatures 'prog-mode
                          '(";;" "::" "&&" "==" "!=" ">>" "<<" "->" "<-" "#{"
                            ":>" "++" "--" "||" "<=" ">=" "/*" "*/" ":=" "!!"
                            "[|" "|]" "{|" "|}" "</" "|=" "//" "**" "%%" "??"))
  ;; Org ligatures
  (ligature-set-ligatures 'org-mode '("==" "!="))
  (global-ligature-mode t))

;; Emojis
(use-package emojify
  :hook (after-init . global-emojify-mode)
  :config
  (setq emojify-composed-text-p t)
  (setq emojify-company-tooltips-p t))

;; Background contrast ricing
(use-package solaire-mode
  :demand t
  :hook
  (after-init . solaire-global-mode))

;; Using buffer focus
(defun real-buffer-p ()
  "Todo docs."
  (or (solaire-mode-real-buffer-p)
      (equal (buffer-name) "*dashboard*")))
(setq solaire-mode-real-buffer-fn #'real-buffer-p)

;; Useless but cute project explorer
(use-package treemacs)

;; Useless but the cutest, use it!
(use-package all-the-icons)

;; Emacs theme ricing
(use-package doom-themes
  :demand t
  :init (load-theme 'doom-moonlight t)
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t))

(use-package doom-modeline
  :init
  (column-number-mode)
  :hook
  (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-icon (display-graphic-p))
  (doom-modeline-major-mode-icon t))
;; END EMACS STYLE

;; START ORG
(defun my/org-mode-setup ()
  "Todo docs."
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook
  (org-mode . my/org-mode-setup)
  :config
  (my/org-font-setup)
  (setq org-startup-folded t)
  (setq org-hide-macro-markers t)
  (setq org-hide-emphasis-markers t)
  (setq org-adapt-indentation t)
  (setq org-hide-leading-stars t)
  (setq org-odd-levels-only t))

(defun my/org-font-setup ()
  "Replace list hyphen with dot."
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.4)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Fira Code" :weight 'bold :height (cdr face))
    )

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org-bullets
  :after org
  :hook
  (org-mode . org-bullets-mode)
  :config
  (setq org-list-demote-modify-bullet '(
                                       ("+" . "-")
                                       ("-" . "*")
                                       ("*" . "+"))
       org-ellipsis " ↴"
       org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")
       org-list-indent-offset 2))

(defun my/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

;; Scratch buffer w/ org
(setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)

(use-package visual-fill-column
  :hook (org-mode . my/org-mode-visual-fill))
;; END ORG

;; START ENVIRONMENT
(use-package restart-emacs
  :commands restart-emacs)

;; Undo tree, not undo line
(use-package undo-tree
  :config
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode))

(use-package pdf-tools
  :after org)

;; Clean up trailing whitespace on edited lines on save
(use-package ws-butler
  :config
  (ws-butler-global-mode))

;; Move lines
(use-package smart-shift
  :bind
  ;; ("C-c <right>" . smart-shift-right)
  ;; ("C-c <left>" . smart-shift-left)
  ("M-<up>" . smart-shift-up)
  ("M-<down>" . smart-shift-down)
  :config
  (global-smart-shift-mode 1))

;; dired
(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook
  (dired-mode . dired-hide-dotfiles-mode))

;; Useful developing tools
(use-package ivy
  :demand t
  :bind
  ("C-x b" . ivy-switch-buffer)
  :config
  (progn
    (setq ivy-use-virtual-buffers t)
    (setq avy-background t)
    (setq ivy-count-format "%d/%d ")
    (setq ivy-display-style 'fancy)))

(use-package all-the-icons-ivy-rich
  :init
  (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :after counsel
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

(use-package counsel
  :init
  (counsel-mode 1)
  :bind
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-M-j" . 'counsel-switch-buffer)
   :map minibuffer-local-map
   ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering-nil)
  :config
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive 'stack)
  (highlight-indent-guides-method 'character))

(use-package swiper
  :bind
  (("C-s" . swiper)
   ("C-c C-r" . ivy-resume))
  :init
  (ivy-mode 1)
  :config
  (progn
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)))

(use-package ripgrep)

(use-package projectile
  :demand t
  ;;:diminish projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-enable-caching t)
  (projectile-verbose nil)
  (projectile-do-log nil))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package which-key
  :defer 1
  ;;:diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

;; Opening file as sudo
(use-package sudo-edit)

(use-package uniquify
  :straight (:type built-in))

(use-package page-break-lines)

;; Dashboard
(use-package dashboard
  :after projectile
  :after all-the-icons
  :after page-break-lines
  :hook
  (after-init . dashboard-setup-startup-hook)
  :config
  (progn
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-center-content t)
    (setq dashboard-projects-backend 'projectile)
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-navigator t)
    (setq dashboard-startup-banner 'official)
    (setq dashboard-banner-logo-title "I wanna became the female & brazillian version of Leo da Vinci")
    (setq dashboard-set-init-info t)
    (setq dashboard-items '((recents  . 5) (bookmarks . 5) (projects . 5)))
    (setq dashboard-footer-messages '("While any text editor can save your files, only Emacs can save your soul"))
    (setq dashboard-footer-icon (all-the-icons-faicon "magic" :height 1.2 :v-adjust 0.0 :face 'font-lock-keyword-face))
    (setq dashboard-image-banner-max-width 240)
    (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))))

(use-package display-line-numbers
  :straight (:type built-in))

(defcustom display-line-numbers-exempt-modes
  '(vterm-mode
    eshell-mode
    shell-mode
    term-mode
    ansi-term-mode
    org-mode
    erc-mode
    treemacs-mode
    elfeed-show-mode
    elfeed-dashboard-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)


(use-package linum-relative
  :hook (prog-mode . linum-relative-mode)
  :config
  (set-face-foreground 'linum "#999")
  (setq linum-relative-current-symbol "->"))

;; Colorize color names
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit))

(use-package company
  :defer 0.5
  ;;:diminish company-mode
  :hook ((prog-mode . company-mode)
         (lsp-mode . company-mode)
         (comint-mode . company-mode))
  :commands (company-mode global-company-mode company-complete
                          company-complete-common company-manual-begin
                          company-grab-line)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("<tab>" . company-complete-selection))
        ;;(:map lsp-mode-map
        ;;      ("<tab>" . company-indent-or-complete-common))
  :config
  (setq lsp-completion-provider :capf)
  (add-to-list 'company-backends
               '(company-yasnippet
                 company-files
                 company-keywords
                 company-capf
                 company-dabbrev
                 company-dabbrev-code))
  :custom
  (company-begin-commands '(self-insert-command))
  (company-require-match nil)
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotation t)
  (company-frontends '(company-pseudo-tooltip-frontend
                       company-echo-metadata-frontend)))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company-quickhelp
  :after company)

;; Numbering for buffers, windows and workspaces
(use-package winum
  :defer 0.5
  :custom
  (winum-auto-setup-mode-line nil)
  :config
  (winum-mode))

(use-package evil-nerd-commenter
  :commands evilnc-comment-or-uncomment-lines
  :bind
  ("M-/" . evilnc-comment-or-uncomment-lines))

;; racket
(use-package racket-mode
  :mode "\\.rkt\\'"
  :hook
  ((racket-mode . racket-xp-mode)
   (racket-mode . racket-smart-open-bracket-mode)))

;;Common Lisp library
(use-package cl-lib
  :straight (:type built-in))

(use-package magit
  :commands magit-status
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

(provide 'init)

(use-package pdf-tools
  :after org)

(setq org-latex-compiler "lualatex")
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-latex-pdf-process (list
                             "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(use-package python-mode
  :mode "\\.py\\'")

(use-package vterm
  :custom (vterm-install t))

;;; init.el ends here
