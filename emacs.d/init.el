;; Package management
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

;; Rust mode and cargo minor mode
(package-install 'rust-mode)
(setq rust-format-on-save t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Repeat last command
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-r" #'(lambda () (interactive)
                           (eval (car command-history))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Formatting using rustfmt
;; See https://emacs.stackexchange.com/questions/19486/help-with-call-process-region-searching-for-program-no-such-file-or-director
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'rust-mode)
(defun rust--format-call (buf)
  "Format BUF using rustfmt."
  (with-current-buffer (get-buffer-create "*rustfmt*")
    (erase-buffer)
    (insert-buffer-substring buf)
    (let* ((tmpf (make-temp-file "rustfmt"))
           (ret (call-process-region (point-min) (point-max) "/root/.cargo/bin/rustfmt"
                                     t `(t ,tmpf) nil "-f")))
      (unwind-protect
          (cond
           ((zerop ret)
            (if (not (string= (buffer-string)
                              (with-current-buffer buf (buffer-string))))
                (copy-to-buffer buf (point-min) (point-max)))
            (kill-buffer))
           ((= ret 3)
            (let ((buffer-read-only nil))
              (if (not (string= (buffer-string)
                                (with-current-buffer buf (buffer-string))))
                  (copy-to-buffer buf (point-min) (point-max)))
              (erase-buffer)
              (insert-file-contents tmpf)
              (error "Rustfmt could not format some lines, see *rustfmt* buffer for details---")))
           (t
            ;;(erase-buffer)
            (insert-file-contents tmpf)
            (error "Rustfmt failed, see *rustfmt* buffer for details ---"))))
      (delete-file tmpf))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Racer for Rust autocompletion
(package-install 'racer)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

;; Company (complete-anything) mode with Racer backend
(package-install 'company)
(add-hook 'racer-mode-hook #'company-mode)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; Flycheck for instant visual feedback
(package-install 'flycheck)
(package-install 'flycheck-rust)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(global-flycheck-mode)

;; Cargo minor mode
(package-install 'cargo)
(global-set-key (kbd "C-c C-t") #'cargo-process-test)

;; Install magic
(package-install 'magit)

;; Eglot language server client
(package-install 'eglot)

;; Load a sane color theme
(load-theme 'wombat)
