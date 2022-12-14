(require 'package)
(setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))
(package-initialize)
;; 刷新Emacs包源
(unless package-archive-contents (package-refresh-contents))

;; 如果use-package没安装，先安装它
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; 加载use-package
(require 'use-package)
(setq use-package-always-ensure t)

;; (menu-bar-mode -1)
(tool-bar-mode -1)

;; Solarized dark
;; doom-themes + doom-modeline, doom-vibrant
(use-package zenburn-theme
  :config (load-theme 'zenburn t))
(use-package diminish :defer t)

(use-package hydra
  :ensure t)

(use-package use-package-hydra
  :ensure t
  :after hydra)

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  (("C-s" . 'swiper)
   ("C-x b" . 'ivy-switch-buffer)
   ("C-c v" . 'ivy-push-view)
   ("C-c s" . 'ivy-switch-view)
   ("C-c V" . 'ivy-pop-view)
   ("C-x C-@" . 'counsel-mark-ring); 在某些终端上 C-x C-SPC 会被映射为 C-x C-@，比如在 macOS 上，所以要手动设置
   ("C-x C-SPC" . 'counsel-mark-ring)
   :map minibuffer-local-map
   ("C-r" . counsel-minibuffer-history)))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c f" . counsel-recentf)
	 ("C-c g" . counsel-git)))
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper-isearch-backward))
  :config (setq swiper-action-recneter t
		swiper-include-line-number-in-search t))
  
(use-package undo-tree
  :ensure t
  :diminish ""
  :init (global-undo-tree-mode)
  :after hydra
  :bind ("C-x C-h u" . hydra-undo-tree/body)
  :hydra (hydra-undo-tree (:hint nil)
  "
  _p_: undo  _n_: redo _s_: save _l_: load   "
  ("p"   undo-tree-undo)
  ("n"   undo-tree-redo)
  ("s"   undo-tree-save-history)
  ("l"   undo-tree-load-history)
  ("u"   undo-tree-visualize "visualize" :color blue)
  ("q"   nil "quit" :color blue)))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :diminish ""
  :ensure t
  :init (which-key-mode))

(use-package which-key-posframe)

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package avy
  :ensure t
  :bind
  (("C-:" . avy-goto-char-timer)))

(use-package ggtags
  :config (setq gtags-path-style 'relative)
  :hook ((c-mode . ggtags-mode)
	 (java-mode . ggtags-mode)
	 (c++-mode . ggtags-mode)))

(use-package slime
  :commands slime
  :init (setq inferior-lisp-program "sbcl")
  :config (slime-setup '(slime-fancy)))

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (global-company-mode t))

(use-package company-irony-c-headers
  :after irony)

(use-package company-irony
  :after (irony company-irony-c-headers)
  :config
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)))

(use-package irony
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'java-mode 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))


(use-package irony-eldoc
  :config
  (add-hook 'irony-mode-hook #'irony-eldoc))

(use-package company-jedi
  :config
  (defun mypython-mode-hook ()
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook '(jedi:setup mypython-mode-hook)))

(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 25)
  (global-set-key "\C-x\ \C-r" 'recentf-open-files))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner 1)
  (dashboard-setup-startup-hook))

(use-package vlf
  :ensure t
  :init
  (add-hook #'vlf-mode-hook #'view-mode)
  (add-hook #'vlf-mode-hook #'read-only-mode)
  (add-hook #'vlf-mode-hook #'hl-line-mode)
  :config
  (require 'vlf-setup)
  (setq vlf-application 'ask)
  (define-key vlf-prefix-map "\C-xv" vlf-mode-map))

(use-package view
  :config
  (defun View-goto-line-last (&optional line)
    "goto last line"
    (interactive "P")
    (goto-line (line-number-at-pos (point-max))))

  (define-key view-mode-map (kbd "e") 'View-scroll-half-page-forward)
  (define-key view-mode-map (kbd "u") 'View-scroll-half-page-backward)

  ;; less like
  (define-key view-mode-map (kbd "N") 'View-search-last-regexp-backward)
  (define-key view-mode-map (kbd "?") 'View-search-regexp-backward?)
  (define-key view-mode-map (kbd "g") 'View-goto-line)
  (define-key view-mode-map (kbd "G") 'View-goto-line-last)
  ;; vi/w3m like
  (define-key view-mode-map (kbd "h") 'backward-char)
  (define-key view-mode-map (kbd "j") 'next-line)
  (define-key view-mode-map (kbd "k") 'previous-line)
  (define-key view-mode-map (kbd "l") 'forward-char))

(use-package projectile
  :bind
  (:map projectile-mode-map
        ("C-c p"   . projectile-command-map))        ;; traditional binding
  :config
  (projectile-mode t))

;;(use-package doom-modeline
;;  :hook (after-init . doom-modeline-mode))

(use-package hideshow
  :bind (("C-c TAB" . hs-toggle-hiding)
         ("C-\\" . hs-toggle-hiding)
         ("M-+" . hs-show-all))
  :init (add-hook #'prog-mode-hook #'hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (setq hs-special-modes-alist
        (mapcar 'purecopy
                '((c-mode "{" "}" "/[*/]" nil nil)
                  (c++-mode "{" "}" "/[*/]" nil nil)
                  (java-mode "{" "}" "/[*/]" nil nil)
                  (js-mode "{" "}" "/[*/]" nil)
                  (json-mode "{" "}" "/[*/]" nil)
                  (javascript-mode  "{" "}" "/[*/]" nil)))))
