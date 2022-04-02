;;; init.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Thanawat Techaumnuaiwit
;;
;; Author: Thanawat Techaumnuaiwit <thanawat@thanawat>
;; Maintainer: Thanawat Techaumnuaiwit <thanawat@thanawat>
;; Created: April 01, 2022
;; Modified: April 01, 2022
;; Version: 0.0.1
;;; Code:



(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(require 'use-package)
(setq use-package-always-ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
