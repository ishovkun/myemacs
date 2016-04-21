;; Install additional packages!!!
;; fill-column-indicator
;; auto-complete
;; elpy
;; auctex
;; powerline
;; switch-window
;; helm
;; ace-jump-mode
;; openwith

;; to save sessions
(desktop-save-mode 1)

;; to select word/line/blosck in increasing order
(defun semnav-up (arg)
  (interactive "p")
  (when (nth 3 (syntax-ppss))
    (if (> arg 0)
        (progn
          (skip-syntax-forward "^\"")
          (goto-char (1+ (point)))
          (decf arg))
      (skip-syntax-backward "^\"")
      (goto-char (1- (point)))
      (incf arg)))
  (up-list arg))

(defun extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (and transient-mark-mode mark-active)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

(global-set-key (kbd "C-x w") 'extend-selection)

;; to coment/uncomment
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if 
     there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
	    (setq beg (line-beginning-position) end
		(line-end-position)))
        (comment-or-uncomment-region beg end)))

; use Alt-; as a commenting shortcut
(global-set-key "\M-;" 'comment-or-uncomment-region-or-line)

; Set Alt-k to kill the line to the left
(global-set-key "\M-k" '(lambda () (interactive) (kill-line 0)) )

(defun kill-current-line ()
  "inserts a new line below and moves cursor to its beginning"
  (interactive)
    (beginning-of-line)
    (kill-line)
    (kill-line)
)

; Set C-S-k to kill the line regardless of the cursor position
(global-set-key [?\C-\S-k] 'kill-current-line)

;; folding
(defun hs-enable-and-toggle ()
  (interactive)
  (hs-minor-mode 1)
  (hs-toggle-hiding))

(defun hs-enable-and-hideshow-all (&optional arg)
  "Hide all blocks. If prefix argument is given, show all blocks."
  (interactive "P")
  (hs-minor-mode 1)
  (if arg
      (hs-show-all)
      (hs-hide-all)))
(global-set-key (kbd "C-c C-h") 'hs-enable-and-toggle)
(global-set-key (kbd "C-c C-j") 'hs-enable-and-hideshow-all)

;; functions to swap lines up and down
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(defun next-word (p)
   "Move point to the beginning of the next word, past any spaces"
   (interactive "d")
   (forward-word)
   (forward-word)
   (backward-word))
(global-set-key "\M-f" 'next-word)

;; remap backward kill to C-w
(global-set-key "\C-w" 'backward-kill-word)
;; remap kill region to \C-W
(global-set-key [?\C-\S-w] 'kill-region)
(global-set-key [\S-\C-w] 'kill-region)

;; set \C-shift-d to delete a char backwards
;; (global-set-key [?\C-\S-d] 'backward-delete-char-untabify)
(global-set-key "\C-z" 'backward-delete-char-untabify)

;; Ctrl-TAB to change pane
(global-set-key [C-tab] 'other-window)

;; \C-a as back to indentation
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

;; add shortcuts to resize windows
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)

;; show line numbers
(global-linum-mode t)

;; enably replacing a selection when pasting into it
(delete-selection-mode t)

;; use imenu on a shortcut
(global-set-key (kbd "C-,") 'imenu)

;; C-x-C-right/left to switch buffers
(global-set-key [C-M-right] 'next-buffer)
(global-set-key [C-M-left] 'previous-buffer)

(defun select-current-line ()
  "Select current line."
  (interactive)
  (back-to-indentation)
  (set-mark (line-end-position)))


(global-set-key "\C-x\C-c" 'select-current-line)

(defun insert-new-line-below ()
  "inserts a new line below and moves cursor to its beginning"
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))

(defun insert-new-line-above ()
  "inserts a new line above and moves cursor to its beginning"
  (interactive)
  (let ((oldpos (point)))
    (beginning-of-line)
    (newline-and-indent)
    (previous-line)
    (indent-for-tab-command)))


(global-set-key (kbd "<C-return>") 'insert-new-line-below)
(global-set-key (kbd "<C-o>") 'insert-new-line-below)
(global-set-key (kbd "<C-S-return>") 'insert-new-line-above)


;; folding
;; (global-semantic-folding-mode t)

;; (global-set-key (kbd "\C-c\C-k") 'delete-process-at-point)
; to use package management and download packages from mepla repo
(require 'package)
(setq package-archives
      '(
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	))

(package-initialize)
;; enumerates frames and allows to choose where to jump
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(require 'imenu)

;; powerline from
;; git clone git://github.com/jonathanchu/emacs-powerline.git
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)

(require 'helm-config)
;; (require 'openwith)

;; ace jump mode major function
;; 
(add-to-list 'load-path "~/.emacs.d/epla/ace-jump-mode-20140616.115")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(electric-pair-mode)
;; set up python
(if (eq 'system-type 'gnu/linux)
    (setq python-shell-interpreter
          "/home/ishovkun/anaconda3/bin/ipython")
  )

(if (eq system-type 'windows-nt)
    (setq python-shell-interpreter
          "c:/Anaconda3/Scripts/ipython")
  )

(setq-default py-shell-name "ipython")
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args "--profile=dev"
 )

;; (setq-default py-which-bufname "IPython")
(setq-default python-shell-interpreter-interactive-arg t)
; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
  '("--gui=wx" "--pylab=wx" "-colors" "Windows"))
(setq py-force-py-shell-name-p t)
(setq python-indent-offset 4)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil) ;; use only spaces and no tabs

;; this is made to make imenu work properly with python
(add-hook 'python-mode-hook
  (lambda ()
    (setq imenu-create-index-function 'python-imenu-create-index)))

;; optimize python shell ouput speed
(setq python-shell-enable-font-lock nil)

; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; don't split windows
(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)

(require 'ido)
;; allow ido to open one buffer in multiple frames
(setq ido-default-buffer-method 'selected-window)

(ido-mode t)

;; ;; auto-completion
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

;; dired copy/paste
(add-to-list 'load-path "~/.emacs.d/wuxch-dired-copy-paste")
(require 'wuxch-dired-copy-paste)
;; predictive mode
(add-to-list 'load-path "~/.emacs.d/predictive")
(autoload 'predictive-mode "predictive" "predictive" t)
(set-default 'predictive-auto-add-to-dict t)
(setq predictive-main-dict 'rpg-dictionary
      predictive-auto-learn t
      ;; predictive-add-to-dict-ask nil
      ;; predictive-use-auto-learn-cache nil
      predictive-which-dict t)
(require 'predictive)

;; latex packages
;; (load "auctex.el" nil t t)

;; spell-checking
(add-hook 'LaTeX-mode-hook '(flyspell-mode t))

;; fci-mode - restrict the maximum number of columns
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)
;; set maximum 68 lines (2-pane view on my laptop)
(setq-default fill-column 68)

;; Set up Python environment
(require 'python)
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
      '("--gui=wx" "--pylab=wx" "-colors" "Linux"))
(setq py-force-py-shell-name-p t)
; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; don't split windows
(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)
;; to compile the whole script with F7
;; (global-set-key (kbd "<f7>") (kbd "C-u C-c C-c"))


;; ---------------------- FreeFem++ --------------------------------
;; add Freefem++ mode
(autoload 'freefem++-mode "freefem++-mode"
        "Major mode for editing FreeFem++ code." t)
(add-to-list 'auto-mode-alist '("\\.edp$" . freefem++-mode))
(add-to-list 'auto-mode-alist '("\\.idp$" . freefem++-mode))

(eval-after-load 'freefem++-mode
  '(global-set-key "\C-c\C-k" 'freefempp-interrupt-process))

;; set default freefem interpreter
(setq freefempp-program "FreeFem++-nw")
;; set shortcut to interrupt FreeFem running

;; --------------------- Python ------------------------------------
;; save association with Python files
(setq auto-mode-alist
      (cons '("SConstruct" . python) auto-mode-alist))

;; set font size before the color sheme

(if (eq system-type 'windows-nt)
    (
     (set-face-attribute 'default nil :family "Consolas")
     (set-face-attribute 'default nil :height 120)
     )
  (set-face-attribute 'default nil :height 110)
     )

;; lose the UI
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(add-to-list 'custom-theme-load-path "~/.emacs.d/color-themes")
(load-theme 'ishovkun t)

; tweak theme a little bit 
(set-face-attribute 'linum nil :background "#0d301c")
(set-face-attribute 'fringe nil :background "#0d301c")

;; set poweline colors
;; (setq powerline-arrow-shape 'arrow)   ;; the default
;; (setq powerline-arrow-shape 'arrow14) ;; best for small fonts
(custom-set-faces
 '(mode-line ((t (:foreground "#fff" :background "#0d301c" :box nil))))
 '(mode-line-inactive ((t (:foreground "#fff" :background "#0d301c" :box nil)))))


(setq powerline-color1 "#2f073c")   ;; dark-green
(setq powerline-color2 "#090c18")   ;; = background color
