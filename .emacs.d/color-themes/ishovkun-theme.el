(deftheme ishovkun "DOCSTRING for ishovkun")
  (custom-theme-set-faces 'ishovkun
   '(default ((t (:foreground "#ffffff" :background "#090c18" ))))
   '(cursor ((t (:background "#f713f4" ))))
   '(fringe ((t (:background "#0e301c" ))))
   '(mode-line ((t (:foreground "#fffcec" :background "#2f073c" ))))
   '(region ((t (:background "#221d4d" ))))
   '(secondary-selection ((t (:background "#271445" ))))
   '(font-lock-builtin-face ((t (:foreground "#b90ab7" ))))
   '(font-lock-comment-face ((t (:foreground "#078121" ))))
   '(font-lock-function-name-face ((t (:foreground "#2ffb19" ))))
   '(font-lock-keyword-face ((t (:foreground "#0ce0d5" ))))
   '(font-lock-string-face ((t (:foreground "#279ef8" ))))
   '(font-lock-type-face ((t (:foreground "#ff0000" ))))
   '(font-lock-constant-face ((t (:foreground "#d8ea00" ))))
   '(font-lock-variable-name-face ((t (:foreground "#18f4e2" ))))
   '(minibuffer-prompt ((t (:foreground "#24d7fb" :bold t ))))
   '(font-lock-warning-face ((t (:foreground "red" :bold t ))))
   )

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                 (file-name-as-directory
                  (file-name-directory load-file-name))))
;; Automatically add this theme to the load path

(provide-theme 'ishovkun)
