;; フォント設定
(setq default-frame-alist
      '((font . "Cica 13")))

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く

(leaf *emacs-theme
  :doc "Emacs テーマ"
  :tag "theme"
  :added "2021-06-27"
  :init
  (leaf zenburn-theme :ensure t)
  :config
  (load-theme 'zenburn t))



(leaf cus-edit
  :doc "tools for customizing Emacs and List packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))
  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom
  ((create-lockfiles . nil)
   (debug-on-error . t)
   (init-file-debug . t)
   (frame-resize-pixelwise . t)
   (enable-recursive-minibuffers . t)
   (history-length . 1000)
   (history-delete-duplicates . t )
   (scroll-preserve-screen-position . t)
   (scroll-conservatively . 100)
   (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
   (ring-bell-function . 'ignore)
   (text-quoting-style . 'straight)
   (truncate-lines . nil)
   (truncate-partial-width-windows . nil)
   (auto-fill-mode . nil)
   (next-line-add-newlines . nil)
   (read-file-name-completion-ignore-case . t)
   (scroll-bar-mode . nil)
   (tool-bar-mode . nil)
   (tab-width . 4)
   (indent-tabs-mode .nil))
  :config
  (when (boundp 'load-prefer-newer)
    (setq load-prefer-newer t))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?)) ;; C-h delete-backward-char


(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
              (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,( locate-user-emacs-file "backup/.saves-"))))

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf *completion
  :init
  ;; 補完で無視する拡張子の追加．そのうち増える．
  (cl-loop for ext in
           '(;; TeX
             ".dvi"
             ".fdb_latexmk"
             ".fls"
             ".ilg"
             ".jqz"
             ".nav"
             ".out"
             ".snm"
             ".synctex\\.gz"
             ".vrb"
             ;; fortran >= 90
             ".mod"
             ;; zsh
             ".zwc"
             ;; libtool
             ".in"
             ".libs/"
             ;; fxxkin Apple
             ".DS_Store"
             "._DS_Store"
             ;; "org-id-locations"
             )
           do (add-to-list 'completion-ignored-extensions ext)))

(leaf vertico
  :doc "minibuffer補完UI"
  :tag "vertico"
  :added "2021-06-28"
  :ensure t
  :custom
  `(vertico-count . 15)
  :config
  (vertico-mode)
  (leaf orderless
    :doc "順不同検索"
    :tag "orderless"
    :added "2021-06-28"
    :ensure t
    :config
    (setq completion-styles '(orderless))))


(leaf which-key
  :doc "キーバインドを教えてくれる"
  :tag "which-key"
  :added "2021-06-28"
  :ensure t
  :config
  (which-key-mode +1)
  (which-key-setup-minibuffer))


(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(macrostep leaf-tree leaf-convert leaf-keywords hydra el-get blackout)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
