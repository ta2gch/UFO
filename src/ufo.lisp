(in-package #:cl-user)
(defpackage ufo
  (:use :cl :anaphora :uiop :ufo.env :ufo.addon)
  (:export :ufo :setup))
(in-package #:ufo)

(defun subcmd-p (subcmd)
  (let* ((ros (make-pathname :name subcmd))
	 (cmd-path (merge-pathnames ros (ufo.env:dot-ufo #p"addon/"))))
    (if (probe-file cmd-path) cmd-path nil)))

(defun setup ()
  (ensure-directories-exist (ufo.env:dot-ufo #p"addon/"))
  (ensure-directories-exist (ufo.env:dot-ufo #p"tmp/"))
  (let ((addon-dir (merge-pathnames
		    "addon/"
		    (ql:where-is-system :ufo))))
    (dolist (addon '("addon-install.ros" "addon-remove.ros"
		     "install.ros" "remove.ros" "update.ros"
		     "help.ros"))
      (ufo.addon:addon (merge-pathnames addon addon-dir)))))

(defun ufo (subcmd &rest argv)
  (setup)
  (acond
   ((subcmd-p subcmd) 
    (uiop:run-program (cons it argv)
		      :output t
		      :error-output *error-output*))
   (t (error "unkown sub-command : ~a~%" subcmd))))
