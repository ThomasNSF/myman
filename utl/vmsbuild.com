$! MyMan build script for OpenVMS
$!
$! Run it from the parent directory like this:
$! $ @[.utl]vmsbuild
$!
$ write sys$output "$! cleaning"
$ delete myman.obj;*
$ delete mygetopt.obj;*
$ delete utils.obj;*
$ delete myman.exe;*
$ write sys$output "$! compiling"
$ cc -
 /define=(-
OLDCURSES,-
USE_IOCTL=0,-
"cbreak=crmode",-
"idlok(s,f)=",-
"mvprintw=mvaddstr") -
 /include_directory=([.inc],[.mygetopt]) -
 [.src]myman.c,[.mygetopt]mygetopt.c,[.src]utils.c
$ write sys$output "$! linking"
$ link myman.obj,utils.obj,mygetopt.obj
$ write sys$output "$! done"
$ write sys$output "$! to run myman, first define a logical:"
$ myman :== "$''f$environment("default")'myman.exe"
$ write sys$output "myman :== ''myman'"