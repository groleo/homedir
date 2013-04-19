#!/bin/sh
#
# Note on portability:
# This script is intended to run on any platform supported by X.Org.
# The Autoconf generated configure script is a good reference as to what is permitted.
# Basically, it should be able to run in a Bourne shell.

envoptions() {
cat << EOF
Environment variables specific to wbuild.sh:
  PREFIX      Install architecture-independent files in PREFIX [/usr/local]
              Each module/components is invoked with --prefix
  EPREFIX     Install architecture-dependent files in EPREFIX [PREFIX]
              Each module/components is invoked with --exec-prefix
  BINDIR      Install user executables [EPREFIX/bin]
              Each module/components is invoked with --bindir
  DATAROOTDIR Install read-only arch-independent data root [PREFIX/share]
              Each module/components is invoked with --datarootdir
  DATADIR     Install read-only architecture-independent data [DATAROOTDIR]
              Each module/components is invoked with --datadir
  LIBDIR      Install object code libraries [EPREFIX/lib]
              Each module/components is invoked with --libdir
  LOCALSTATEDIR
              Modifiable single-machine data [PREFIX/var]
              Each module/components is invoked with --localstatedir
  QUIET       Do not print messages saying which checks are being made
              Each module/components is invoked with --quite
  GITROOT     Source code repository path [git://anongit.freedesktop.org/git]
              Optional when using --clone to update source code before building
  CONFFLAGS   Configure options to pass to all Autoconf configure scripts
              Refer to 'configure --help' from any module/components

Environment variables defined by the GNU Build System:
  ACLOCAL     The aclocal cmd name [aclocal -I \${DESTDIR}/\${DATADIR}/aclocal]
  DESTDIR     Path to the staging area where installed objects are relocated
  MAKE        The name of the make command [make]
  MAKEFLAGS   Options to pass to all \$(MAKE) invocations
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  CPPFLAGS    C/C++/Objective C preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor

Environment variables defined by the shell:
  PATH        List of directories that the shell searches for commands
              \$DESTDIR/\$BINDIR is prepended

Environment variables defined by the dynamic linker:
  LD_LIBRARY_PATH
              List directories that the linker searches for shared objects
              \$DESTDIR/\$LIBDIR is prepended

Environment variables defined by the pkg-config system:
  PKG_CONFIG_PATH
              List directories that pkg-config searches for libraries
              \$DESTDIR/\$DATADIR/pkgconfig and
              \$DESTDIR/\$LIBDIR/pkgconfig are prepended
EOF
}

setup_buildenv() {

    # Remember if the user had supplied a value through env var or cmd line
    # A value from cmd line takes precedence of the shell environment
    PREFIX_USER=${PREFIX:+yes}
    EPREFIX_USER=${EPREFIX:+yes}
    BINDIR_USER=${BINDIR:+yes}
    DATAROOTDIR_USER=${DATAROOTDIR:+yes}
    DATADIR_USER=${DATADIR:+yes}
    LIBDIR_USER=${LIBDIR:+yes}
    LOCALSTATEDIR_USER=${LOCALSTATEDIR:+yes}

    # Assign a default value if no value was supplied by the user
    PREFIX=${PREFIX:-/usr/local}
    EPREFIX=${EPREFIX:-$PREFIX}
    BINDIR=${BINDIR:-$EPREFIX/bin}
    DATAROOTDIR=${DATAROOTDIR:-$PREFIX/share}
    DATADIR=${DATADIR:-$DATAROOTDIR}
    LIBDIR=${LIBDIR:-$EPREFIX/lib}
    LOCALSTATEDIR=${LOCALSTATEDIR:-$PREFIX/var}

    # Support previous usage of LIBDIR which was a subdir relative to PREFIX
    # We use EPREFIX as this is what PREFIX really meant at the time
    if [ X"$LIBDIR" != X ]; then
    if [ X"`expr $LIBDIR : "\(.\)"`" != X/ ]; then
        echo ""
        echo "Warning: this usage of \$LIBDIR is deprecated. Use a full path name."
        echo "The supplied value \"$LIBDIR\" has been replaced with $EPREFIX/$LIBDIR."
        echo ""
        LIBDIR=$EPREFIX/$LIBDIR
    fi
    fi

    # All directories variables must be full path names
    check_full_path $PREFIX PREFIX
    check_full_path $EPREFIX EPREFIX
    check_full_path $BINDIR BINDIR
    check_full_path $DATAROOTDIR DATAROOTDIR
    check_full_path $DATADIR DATADIR
    check_full_path $LIBDIR LIBDIR
    check_full_path $LOCALSTATEDIR LOCALSTATEDIR

    # This will catch the case where user forgets to set PREFIX
    # and does not have write permission in the /usr/local default location
    check_writable_dir ${DESTDIR}${PREFIX} PREFIX

    # Must create local aclocal dir or aclocal fails
    ACLOCAL_LOCALDIR="${DESTDIR}${DATADIR}/aclocal"
    $SUDO mkdir -p ${ACLOCAL_LOCALDIR}

    # The following is required to make aclocal find our .m4 macros
    ACLOCAL=${ACLOCAL:="aclocal"}
    ACLOCAL="${ACLOCAL} -I ${ACLOCAL_LOCALDIR}"
    export ACLOCAL

    # The following is required to make pkg-config find our .pc metadata files
    PKG_CONFIG_PATH=${DESTDIR}${DATADIR}/pkgconfig:${DESTDIR}${LIBDIR}/pkgconfig${PKG_CONFIG_PATH+:$PKG_CONFIG_PATH}
    export PKG_CONFIG_PATH

    # Set the library path so that locally built libs will be found by apps
    LD_LIBRARY_PATH=${DESTDIR}${LIBDIR}${LD_LIBRARY_PATH+:$LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH

    # Set the path so that locally built apps will be found and used
    PATH=${DESTDIR}${BINDIR}${PATH+:$PATH}
    export PATH

    # Choose which make program to use
    MAKE=${MAKE:="make"}

    # Create the log file directory
    $SUDO mkdir -p ${DESTDIR}${LOCALSTATEDIR}/log
}

# explain where a failure occurred
# if you find this message in the build output it can help tell you where the failure occurred
# arguments:
#   $1 - which command failed
#   $2/$3 - which module/component failed
# returns:
#   (irrelevant)
failed() {
    cmd=$1
    module=$2
    component=$3
    echo "wbuild.sh: \"$cmd\" failed on $module/$component"
    failed_components="$failed_components $module/$component"
}

# print a pretty title to separate the processing of each module
# arguments:
#   $1 - module
#   $2 - component
#   $3 - configuration options
# returns:
#   (irrelevant)
module_title() {
    module=$1
    component=$2
    confopts="$3"
    # preconds
    if [ X"$module" = X ]; then
    return
    fi

    echo ""
    echo "======================================================================"
    echo "==  Processing module/component:  \"$module/$component\""
    echo "==        configuration options:  $CONFFLAGS $confopts"
}

checkfortars() {
    module=$1
    component=$2
    case $module in
        "data")
            case $component in
                "cursors") component="xcursor-themes" ;;
                "bitmaps") component="xbitmaps" ;;
            esac
            ;;
        "font")
            if [ X"$component" != X"encodings" ]; then
                component="font-$component"
            fi
            ;;
        "lib")
            case $component in
                "libXRes") component="libXres" ;;
                "libxtrans") component="xtrans" ;;
                "libXau") component="Xau" ;;
            esac
            ;;
        "pixman")
            module="lib"
            component="pixman"
            ;;
        "proto")
            case $component in
                "x11proto") component="xproto" ;;
                "xextproto") component="xextproto" ;;
                "inputproto") component="inputproto" ;;
            esac
            ;;
        "util")
            case $component in
                "cf") component="xorg-cf-files" ;;
                "macros") component="util-macros" ;;
            esac
            ;;
        "xcb")
            case $component in
                "proto")
                    module="xcb/proto"
                    component="xcb-proto"
                    ;;
                "pthread-stubs")
                    module="xcb/pthread-stubs"
                    component="libpthread-stubs"
                    ;;
                "libxcb")
                    module="xcb/libxcb"
                    component="libxcb"
                    ;;
                util*)
                    module="xcb/$component"
                    component="xcb-$component"
                    ;;
            esac
            ;;
        "mesa")
            case $component in
                "drm")
                    module="mesa/drm"
                    component="libdrm"
                    ;;
                "mesa")
                    module="mesa/mesa"
                    component="MesaLib"
                    ;;
            esac
            ;;
        "xkeyboard-config")
            component="xkeyboard-config"
            ;;
        "wayland")
            case $component in
                "wayland")
                    module="wayland"
                    component="wayland"
                    ;;
                "weston")
                    module="wayland"
                    component="weston"
                    ;;
            esac
            ;;
    esac
    for ii in $module .; do
        for jj in bz2 gz; do
            TARFILE=`ls -1rt $ii/$component-*.tar.$jj 2> /dev/null | tail -n 1`
            if [ X"$TARFILE" != X ]; then
                SRCDIR=`echo $TARFILE | sed "s,.tar.$jj,,"`
                SRCDIR=`echo $SRCDIR | sed "s,MesaLib,Mesa,"`
                if [ ! -d $SRCDIR ]; then
                    TAROPTS=xjf
                    if [ X"$jj" = X"gz" ]; then
                        TAROPTS=xzf
                    fi
                    tar $TAROPTS $TARFILE -C $ii
            if [ $? -ne 0 ]; then
            failed tar $module $component
            return 1
            fi
                fi
                return 0
            fi
        done
    done

    return 0
}

# perform a clone of a git repository
# this function provides the mapping between module/component names
# and their location in the fd.o repository
# arguments:
#   $1 - module
#   $2 - component (optional)
# returns:
#   0 - good
#   1 - bad
clone() {
    module=$1
    component=$2
    # preconds
    if [ X"$module" = X ]; then
    echo "clone() required first argument is missing"
    return 1
    fi

    case $module in
    "pixman")
        BASEDIR=""
        ;;
    "xcb")
        BASEDIR=""
        ;;
    "mesa")
        BASEDIR=""
        ;;
    "wayland")
        BASEDIR=""
        ;;
    "cairo")
        BASEDIR=""
        ;;
    "xkeyboard-config")
        BASEDIR=""
        ;;
    *)
        BASEDIR="xorg/"
        ;;
    esac

    DIR="$module/$component"
    GITROOT=${GITROOT:="git://anongit.freedesktop.org/git"}

    if [ ! -d "$DIR" ]; then
        echo  "Cloning: $GITROOT/$BASEDIR$DIR $DIR"
        git clone "$GITROOT/$BASEDIR$DIR" "$DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to clone $module module component $component. Ignoring."
            clonefailed_components="$clonefailed_components $module/$component"
            return 1
        fi
    old_pwd=`pwd`
    cd $DIR
    if [ $? -ne 0 ]; then
            echo "Failed to cd to $module module component $component. Ignoring."
            clonefailed_components="$clonefailed_components $module/$component"
            return 1
    return 1
    fi
    git submodule init
        if [ $? -ne 0 ]; then
            echo "Failed to initialize $module module component $component submodule. Ignoring."
            clonefailed_components="$clonefailed_components $module/$component"
            return 1
        fi
    git submodule update
        if [ $? -ne 0 ]; then
            echo "Failed to update $module module component $component submodule. Ignoring."
            clonefailed_components="$clonefailed_components $module/$component"
            return 1
        fi
    cd ${old_pwd}
    else
        echo "git cannot clone into an existing directory $module/$component"
    return 1
    fi

    return 0
}

# perform processing of each module/component
# arguments:
#   $1 - module
#   $2 - component
#   $3 - configure options
# returns:
#   0 - good
#   1 - bad
process() {
    needs_config=0

    module=$1
    component=$2
    confopts="$3"
    # preconds
    if [ X"$module" = X ]; then
    echo "process() required first argument is missing"
    return 1
    fi

    module_title $module "$component" "$confopts"

    SRCDIR=""
    CONFCMD=""
    if [ -f $module/$component/autogen.sh ]; then
        SRCDIR="$module/$component"
        CONFCMD="autogen.sh"
    elif [ X"$CLONE" != X ]; then
        clone $module $component
        if [ $? -eq 0 ]; then
        SRCDIR="$module/$component"
        CONFCMD="autogen.sh"
        fi
    needs_config=1
    else
        checkfortars $module $component
        CONFCMD="configure"
    fi

    if [ X"$SRCDIR" = X ]; then
        echo "$module module component $component does not exist, skipping."
        nonexistent_components="$nonexistent_components $module/$component"
        return 0
    fi

    old_pwd=`pwd`
    cd $SRCDIR
    if [ $? -ne 0 ]; then
    failed cd1 $module $component
    return 1
    fi

    if [ X"$GITCMD" != X ]; then
    $GITCMD
    rtn=$?
    cd $old_pwd

    if [ $rtn -ne 0 ]; then
        failed "$GITCMD" $module $component
        return 1
    fi
    return 0
    fi

    if [ X"$PULL" != X ]; then
    git pull --rebase
    if [ $? -ne 0 ]; then
        failed "git pull" $module $component
        cd $old_pwd
        return 1
    fi
    # The parent module knows which commit the submodule should be at
    git submodule update
        if [ $? -ne 0 ]; then
        failed "git submodule update" $module $component
            return 1
        fi
    fi

    # Build outside source directory
    if [ X"$DIR_ARCH" != X ] ; then
    mkdir -p "$DIR_ARCH"
    if [ $? -ne 0 ]; then
        failed mkdir $module $component
        cd $old_pwd
        return 1
    fi
    cd "$DIR_ARCH"
    if [ $? -ne 0 ]; then
        failed cd2 $module $component
        cd ${old_pwd}
        return 1
    fi
    fi

    # Use "sh autogen.sh" since some scripts are not executable in CVS
    if [ $needs_config -eq 1 ] || [ X"$NOAUTOGEN" = X ]; then
    sh ${DIR_CONFIG}/${CONFCMD} \
        ${PREFIX_USER:+--prefix="$PREFIX"} \
        ${EPREFIX_USER:+--exec-prefix="$EPREFIX"} \
        ${BINDIR_USER:+--bindir="$BINDIR"} \
        ${DATAROOTDIR_USER:+--datarootdir="$DATAROOTDIR"} \
        ${DATADIR_USER:+--datadir="$DATADIR"} \
        ${LIBDIR_USER:+--libdir="$LIBDIR"} \
        ${LOCALSTATEDIR_USER:+--localstatedir="$LOCALSTATEDIR"} \
        ${QUIET:+--quiet} \
        ${CONFFLAGS} $confopts \
        ${CC:+CC="$CC"} \
        ${CPP:+CPP="$CPP"} \
        ${CPPFLAGS:+CPPFLAGS="$CPPFLAGS"} \
        ${CFLAGS:+CFLAGS="$CFLAGS"} \
        ${LDFLAGS:+LDFLAGS="$LDFLAGS"}
    if [ $? -ne 0 ]; then
        failed ${CONFCMD} $module $component
        cd $old_pwd
        return 1
    fi
    fi

    # A custom 'make' target list was supplied through --cmd option
    if [ X"$MAKECMD" != X ]; then
    ${MAKE} $MAKEFLAGS $MAKECMD
    rtn=$?
    cd $old_pwd

    if [ $rtn -ne 0 ]; then
        failed "$MAKE $MAKEFLAGS $MAKECMD" $module $component
        return 1
    fi
    return 0
    fi

    if [ X"$CLEAN" != X ]; then
    ${MAKE} $MAKEFLAGS clean
    if [ $? -ne 0 ]; then
        failed "$MAKE $MAKEFLAGS clean" $module $component
        cd $old_pwd
        return 1
    fi

    fi
    ${MAKE} $MAKEFLAGS
    if [ $? -ne 0 ]; then
    # Rerun with Automake silent rules disabled to see failing gcc statement
    if [ X"$RETRY_VERBOSE" != X ]; then
        echo ""
        echo "wbuild.sh: Rebuilding $component with Automake silent rules disabled"
        ${MAKE} $MAKEFLAGS V=1
    fi
    failed "$MAKE $MAKEFLAGS" $module $component
    cd $old_pwd
    return 1
    fi

    if [ X"$CHECK" != X ]; then
    ${MAKE} $MAKEFLAGS check
    if [ $? -ne 0 ]; then
        failed "$MAKE $MAKEFLAGS check" $module $component
        cd $old_pwd
        return 1
    fi
    fi

    if [ X"$DIST" != X ]; then
    ${MAKE} $MAKEFLAGS dist
    if [ $? -ne 0 ]; then
        failed "$MAKE $MAKEFLAGS dist" $module $component
        cd $old_pwd
        return 1
    fi
    fi

    if [ X"$DISTCHECK" != X ]; then
    ${MAKE} $MAKEFLAGS distcheck
    if [ $? -ne 0 ]; then
        failed "$MAKE $MAKEFLAGS distcheck" $module $component
        cd $old_pwd
        return 1
    fi
    fi

    $SUDO env LD_LIBRARY_PATH=$LD_LIBRARY_PATH ${MAKE} $MAKEFLAGS install
    if [ $? -ne 0 ]; then
    failed "$SUDO env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $MAKE $MAKEFLAGS install" $module $component
    cd $old_pwd
    return 1
    fi

    cd ${old_pwd}

    return 0
}

# process each module/component and handle:
# LISTONLY, RESUME, NOQUIT, and BUILD_ONE
# arguments:
#   $1 - module
#   $2 - component
#   $3 - configure options
# returns:
#   0 - good
#   1 - bad
build() {
    module=$1
    component=$2
    confopts="$3"
    if [ X"$LISTONLY" != X ]; then
    echo "$module/$component"
    return 0
    fi

    if [ X"$RESUME" != X ]; then
    if [ X"$RESUME" = X"$module/$component" ]; then
        unset RESUME
        # Resume build at this module
    else
        echo "Skipping $module module component $component..."
        return 0
    fi
    fi

    process $module "$component" "$confopts"
    process_rtn=$?
    if [ X"$BUILT_MODULES_FILE" != X ]; then
    if [ $process_rtn -ne 0 ]; then
        echo "FAIL: $module/$component" >> $BUILT_MODULES_FILE
    else
        echo "PASS: $module/$component" >> $BUILT_MODULES_FILE
    fi
    fi

    if [ $process_rtn -ne 0 ]; then
    echo "wbuild.sh: error processing module/component:  \"$module/$component\""
    if [ X"$NOQUIT" = X ]; then
        exit 1
    fi
    return $process_rtn
    fi

    if [ X"$BUILD_ONE" != X ]; then
    echo "Single-component build complete"
    exit 0
    fi
}
################################################################3
################################################################3

# protocol headers have no build order dependencies
build_proto() {
    build proto x11proto
    build proto dri2proto
    build proto fixesproto
    build proto glproto
    build proto kbproto
    build proto xextproto
    build proto inputproto
    build proto damageproto
    build proto renderproto
    build xcb proto
}

# bitmaps is needed for building apps, so has to be done separately first
# cursors depends on apps/xcursorgen
# xkbdata is obsolete - use xkbdesc from xkeyboard-config instead
build_data() {
#    build data bitmaps
    build data cursors
}

# All protocol modules must be installed before the libs (okay, that's an
# overstatement, but all protocol modules should be installed anyway)
#
# the libraries have a dependency order:
# xtrans, Xau, Xdmcp before anything else
# fontenc before Xfont
# ICE before SM
# X11 before Xext
# (X11 and SM) before Xt
# Xt before Xmu and Xpm
# Xext before any other extension library
# Xfixes before Xcomposite
# Xp before XprintUtil before XprintAppUtil
#
build_lib() {
    build lib libxtrans
    build lib libXau 
    build xcb pthread-stubs
    build xcb libxcb
    build lib libX11
    build lib libXext
    build lib libXfixes
    build lib libXrender
    build lib libXdamage
    build lib libXcursor


    build lib libpciaccess
    build lib libxkbcommon "--with-xkb-config-root=/usr/share/X11/xkb"
    build pixman ""
}

# Most apps depend at least on libX11.
#
# bdftopcf depends on libXfont
# mkfontscale depends on libfontenc and libfreetype
# mkfontdir depends on mkfontscale
#
# TODO: detailed breakdown of which apps require which libs
build_app() {
    :
}

build_mesa() {
    build mesa drm  "--enable-nouveau-experimental-api"
    build mesa mesa "--enable-gles2 --disable-gallium-egl --with-gallium-drivers="" --with-egl-platforms=wayland,x11,drm --enable-gbm --enable-shared-glapi"
    #build mesa mesa "--enable-gles2 --disable-gallium-egl --with-gallium-drivers="" --with-egl-platforms=wayland,drm --enable-gbm --enable-shared-glapi"
}

# The server requires at least the following libraries:
# Xfont, Xau, Xdmcp, pciaccess
build_wayland() {
    build wayland wayland "--disable-documentation"
}

build_weston() {
    build wayland weston "--with-cairo-glesv2 --disable-setuid-install --disable-xwayland --enable-drm-compositor --enable-fbdev-compositor --disable-libunwind"
#    build wayland weston "--disable-setuid-install --disable-xwayland --enable-drm-compositor --enable-fbdev-compositor --disable-libunwind"
}

build_driver_input() {
    :
}

build_driver_video() {
    :
}

# The server must be built before the drivers
build_driver() {
    # XQuartz doesn't need these...
    case $HOST_OS in
        Darwin) return 0 ;;
    esac

    build_driver_input
    build_driver_video
}

# All fonts require mkfontscale and mkfontdir to be available
#
# The following fonts require bdftopcf to be available:
#   adobe-100dpi, adobe-75dpi, adobe-utopia-100dpi, adobe-utopia-75dpi,
#   arabic-misc, bh-100dpi, bh-75dpi, bh-lucidatypewriter-100dpi,
#   bh-lucidatypewriter-75dpi, bitstream-100dpi, bitstream-75dpi,
#   cronyx-cyrillic, cursor-misc, daewoo-misc, dec-misc, isas-misc,
#   jis-misc, micro-misc, misc-cyrillic, misc-misc, mutt-misc,
#   schumacher-misc, screen-cyrillic, sony-misc, sun-misc and
#   winitzki-cyrillic
#
# The font util component must be built before any of the fonts, since they
# use the fontutil.m4 installed by it.   (As do several other modules, such
# as libfontenc and app/xfs, which is why it is moved up to the top.)
#
# The alias component is recommended to be installed after the other fonts
# since the fonts.alias files reference specific fonts installed from the
# other font components
build_font() {
    :
}

# makedepend requires xproto
build_util() {
    :
    #build util gccmakedep

    #build xkeyboard-config ""
}

# xorg-docs requires xorg-sgml-doctools
build_doc() {
    build doc wayland-docs
}

# just process the sub-projects supplied in the given file ($MODFILE)
# in the order in which they are found in the list
# (prerequisites and ordering are the responsibility of the user)
# globals used:
#   $MODFILE - readable file containing list of modules to process
#              and their optional configuration options
# arguments:
#   (none)
# returns:
#   0 - good
#   1 - bad
process_module_file() {
    # preconds
    if [ X"$MODFILE" = X ]; then
    echo "internal process_module_file() error, \$MODFILE is empty"
    return 1
    fi
    if [ ! -r "$MODFILE" ]; then
    echo "module file '$MODFILE' is not readable or does not exist"
    return 1
    fi

    # read from input file, skipping blank and comment lines
    while read line; do
    # skip blank lines
    if [ X"$line" = X ]; then
        continue
    fi

    # skip comment lines
    echo "$line" | grep "^#" > /dev/null
    if [ $? -eq 0 ]; then
        continue
    fi

    module=`echo $line | cut -d' ' -f1 | cut -d'/' -f1`
    component=`echo $line | cut -d' ' -f1 | cut -d'/' -f2`
    confopts_check=`echo $line | cut -d' ' -f2-`
    if [ "$module/$component" = "$confopts_check" ]; then
        confopts=""
    else
        confopts="$confopts_check"
    fi
    build $module "$component" "$confopts"
    done <"$MODFILE"

    return 0
}

usage() {
    basename="`expr "//$0" : '.*/\([^/]*\)'`"
    echo "Usage: $basename [options] [prefix]"
    echo "Options:"
    echo "  -a          Do NOT run auto config tools (autogen.sh, configure)"
    echo "  -b          Use .build.unknown build directory"
    echo "  -c          Run make clean in addition to \"all install\""
    echo "  -D          Run make dist in addition to \"all install\""
    echo "  -d          Run make distcheck in addition \"all install\""
    echo "  -g          Compile and link with debug information"
    echo "  -h, --help  Display this help and exit successfully"
    echo "  -n          Do not quit after error; just print error message"
    echo "  -o <module/component>"
    echo "              Build just this <module/component>"
    echo "  -p          Update source code before building (git pull --rebase)"
    echo "  -s <sudo>   The command name providing superuser privilege"
    echo "  --autoresume <file>"
    echo "              Append module being built to, and autoresume from, <file>"
    echo "  --check     Run make check in addition \"all install\""
    echo "  --clone     Clone non-existing repositories (uses \$GITROOT if set)"
    echo "  --cmd <cmd> Execute arbitrary git, gmake, or make command <cmd>"
    echo "  --confflags <options>"
    echo "              Pass <options> to autgen.sh/configure of all modules"
    echo "  --modfile <file>"
    echo "              Only process the module/components specified in <file>"
    echo "              Any text after, and on the same line as, the module/component"
    echo "              is assumed to be configuration options for the configuration"
    echo "              of each module/component specifically"
    echo "  --retry-v1  Remake 'all' on failure with Automake silent rules disabled"
    echo "  -L          Just list modules to build"
    echo ""
    envoptions
}

# Ensure the named variable value contains a full path name
# arguments:
#   $1 - the variable value (the path to examine)
#   $2 - the name of the variable
# returns:
#   returns nothing or exit on error with message
check_full_path () {
    path=$1
    varname=$2
    if [ X"`expr $path : "\(.\)"`" != X/ ]; then
    echo "The path \"$path\" supplied by \"$varname\" must be a full path name"
    echo ""
    usage
    exit 1
    fi
}

# Ensure the named variable value contains a writable directory
# arguments:
#   $1 - the variable value (the path to examine)
#   $2 - the name of the variable
# returns:
#   returns nothing or exit on error with message
check_writable_dir () {
    path=$1
    varname=$2
    if [ X"$SUDO" = X ]; then
    if [ ! -d "$path" ] || [ ! -w "$path" ]; then
        echo "The path \"$path\" supplied by \"$varname\" must be a writable directory"
        echo ""
        usage
        exit 1
    fi
    fi
}

# perform sanity checks on cmdline args which require arguments
# arguments:
#   $1 - the option being examined
#   $2 - the argument to the option
# returns:
#   if it returns, everything is good
#   otherwise it exit's
required_arg() {
    option=$1
    arg=$2
    # preconds
    if [ X"$option" = X ]; then
    echo "internal required_arg() error, missing first argument"
    exit 1
    fi

    # check for an argument
    if [ X"$arg" = X ]; then
    echo "the '$option' option is missing its required argument"
    echo ""
    usage
    exit 1
    fi

    # does the argument look like an option?
    echo $arg | grep "^-" > /dev/null
    if [ $? -eq 0 ]; then
    echo "the argument '$arg' of option '$option' looks like an option itself"
    echo ""
    usage
    exit 1
    fi
}

#------------------------------------------------------------------------------
#            Script main line
#------------------------------------------------------------------------------

# Initialize variables controlling end of run reports
failed_components=""
nonexistent_components=""
pullfailed_components=""
clonefailed_components=""

# Set variables supporting multiple binaries for a single source tree
HAVE_ARCH="`uname -i`"
DIR_ARCH=""
DIR_CONFIG="."

# Set variables for conditionally building some components
HOST_OS=`uname -s`
export HOST_OS
HOST_CPU=`uname -m`
export HOST_CPU

# Process command line args
while [ $# != 0 ]
do
    case $1 in
    -a)
    NOAUTOGEN=1
    ;;
    -b)
    DIR_ARCH=".build.$HAVE_ARCH"
    DIR_CONFIG=".."
    ;;
    -c)
    CLEAN=1
    ;;
    -D)
    DIST=1
    ;;
    -d)
    DISTCHECK=1
    ;;
    -g)
    CFLAGS="${CFLAGS} -g3 -O0"
    ;;
    -h|--help)
    usage
    exit 0
    ;;
    -L)
    LISTONLY=1
    ;;
    -n)
    NOQUIT=1
    ;;
    -o)
    if [ -n "$BUILT_MODULES_FILE" ]; then
        echo "The '-o' and '--autoresume' options are mutually exclusive."
        usage
        exit 1
    fi
    required_arg $1 $2
    shift
    RESUME=$1
    BUILD_ONE=1
    ;;
    -p)
    PULL=1
    ;;
    -s)
    required_arg $1 $2
    shift
    SUDO=$1
    ;;
    --autoresume)
    if [ -n "$BUILD_ONE" ]; then
        echo "The '-o' and '--autoresume' options are mutually exclusive."
        usage
        exit 1
    fi
    required_arg $1 $2
    shift
    BUILT_MODULES_FILE=$1
    ;;
    --check)
    CHECK=1
    ;;
    --clone)
    CLONE=1
    ;;
    --run)
    RUN_WESTON=1
    ;;
    --cmd)
    required_arg $1 $2
    shift
    cmd1=`echo $1 | cut -d' ' -f1`
    cmd2=`echo $1 | cut -d' ' -f2`

    # verify the command exists
    which $cmd1 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "The specified command '$cmd1' does not appear to exist"
        echo ""
        usage
        exit 1
    fi

    case X"$cmd1" in
        X"git")
        GITCMD=$1
        ;;
        X"make" | X"gmake")
        MAKECMD=$cmd2
        ;;
        *)
        echo "The script can only process 'make', 'gmake', or 'git' commands"
        echo "It can't process '$cmd1' commands"
        echo ""
        usage
        exit 1
        ;;
    esac
    ;;
    --confflags)
    shift
    CONFFLAGS=$1
    ;;
    --modfile)
    required_arg $1 $2
    shift
    if [ ! -r "$1" ]; then
        echo "can't find/read file '$1'"
        exit 1
    fi
    MODFILE=$1
    ;;
    --retry-v1)
    RETRY_VERBOSE=1
    ;;
    *)
    if [ X"$too_many" = Xyes ]; then
        echo "unrecognized and/or too many command-line arguments"
        echo "  PREFIX:               $PREFIX"
        echo "  Extra arguments:      $1"
        echo ""
        usage
        exit 1
    fi

    # check that 'prefix' doesn't look like an option
    echo $1 | grep "^-" > /dev/null
    if [ $? -eq 0 ]; then
        echo "'prefix' appears to be an option"
        echo ""
        usage
        exit 1
    fi

    PREFIX=$1
    too_many=yes
    ;;
    esac

    shift
done

if [ X"$RUN_WESTON" != X ]; then
    echo "Run weston"
    setup_buildenv
    export MESA_DEBUG=1
    export WAYLAND_DEBUG=1
    export LIBGL_DEBUG=verbose
    export EGL_LOG_LEVEL=debug
    export XDG_RUNTIME_DIR=${HOME}/xdg_wayland
    sudo rm -rf $XDG_RUNTIME_DIR
    mkdir $XDG_RUNTIME_DIR
    chmod 0700 $XDG_RUNTIME_DIR
    sudo chown $USER  $XDG_RUNTIME_DIR
    cp wayland/weston/weston.ini ~/.config/
    if [ "" = "$(groups | grep weston-launch)" ] ; then sudo groupadd weston-launch ; fi
    sudo usermod -a -G weston-launch $USER
    sudo chown root ${PREFIX}/bin/weston-launch
    sudo chmod +s ${PREFIX}/bin/weston-launch
    if [ "" = "$(grep XDG_RUNTIME_DIR /etc/environment)" ] ; then
        sudo sh -c "echo XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} >> /etc/environment"
    fi
    sudo -E ${PREFIX}/bin/weston -Bfbdev-backend.so
    #sudo -E gdb ${PREFIX}/bin/weston
    #sudo -E ${PREFIX}/bin/weston-launch -- -Bfbdev-backend.so
    exit 0
fi

# All user input has been obtained, set-up the user shell variables
if [ X"$LISTONLY" = X ]; then
    setup_buildenv
    echo "Building to run $HOST_OS / $HOST_CPU ($HOST)"
    date
fi

# if   there is a BUILT_MODULES_FILE
# then start off by checking for and trying to build any modules which failed
#      and aren't the last line
if [ X"$BUILT_MODULES_FILE" != X -a -r "$BUILT_MODULES_FILE" ]; then
    built_lines=`cat $BUILT_MODULES_FILE | wc -l | sed 's:^ *::'`
    built_lines_m1=`expr $built_lines - 1`
    orig_BUILT_MODULES_FILE=$BUILT_MODULES_FILE
    unset BUILT_MODULES_FILE
    curline=1
    while read line; do
    built_status=`echo $line | cut -c-6`
    if [ X"$built_status" = X"FAIL: " ]; then
        line=`echo $line | cut -c7-`
        module=`echo $line | cut -d' ' -f1 | cut -d'/' -f1`
        component=`echo $line | cut -d' ' -f1 | cut -d'/' -f2`
        confopts_check=`echo $line | cut -d' ' -f2-`
        if [ "$module/$component" = "$confopts_check" ]; then
        confopts=""
        else
        confopts="$confopts_check"
        fi

        build_ret=""

        # quick check for the module in $MODFILE (if present)
        if [ X"$MODFILE" = X ]; then
        build $module "$component" "$confopts"
        if [ $? -eq 0 ]; then
            build_ret="PASS"
        fi
        else
        cat $MODFILE | grep "$module/$component" > /dev/null
        if [ $? -eq 0 ]; then
            build $module "$component" "$confopts"
            if [ $? -eq 0 ]; then
            build_ret="PASS"
            fi
        fi
        fi

        if [ X"$build_ret" = X"PASS" ]; then
        built_temp=`mktemp`
        if [ $? -ne 0 ]; then
            echo "can't create tmp file, $orig_BUILT_MODULES_FILE not modified"
        else
            head -n `expr $curline - 1` $orig_BUILT_MODULES_FILE > $built_temp
            echo "PASS: $module/$component" >> $built_temp
            tail -n `expr $built_lines - $curline` $orig_BUILT_MODULES_FILE >> $built_temp
            mv $built_temp $orig_BUILT_MODULES_FILE
        fi
        fi
    fi
    if [ $curline -eq $built_lines_m1 ]; then
        break
    fi
    curline=`expr $curline + 1`
    done <"$orig_BUILT_MODULES_FILE"

    BUILT_MODULES_FILE=$orig_BUILT_MODULES_FILE
    RESUME=`tail -n 1 $BUILT_MODULES_FILE | cut -c7-`

    # remove last line of $BUILT_MODULES_FILE
    # to avoid a duplicate entry
    built_temp=`mktemp`
    if [ $? -ne 0 ]; then
    echo "can't create tmp file, last built item will be duplicated"
    else
    head -n $built_lines_m1 $BUILT_MODULES_FILE > $built_temp
    mv $built_temp $BUILT_MODULES_FILE
    fi
fi

if [ X"$MODFILE" = X ]; then
    # We must install the global macros before anything else
    build util macros
    build font util

    build_doc
    build_proto
    # Required by mesa and depends on xproto
    build util makedepend
    build_lib
    build cairo "" "--enable-glesv2=yes  --enable-egl=yes"
    build_wayland
    build_mesa
    build_weston

    build data bitmaps
    build_app
    build_driver
    build_data
    build_font
    build_util
else
    process_module_file
fi

if [ X"$LISTONLY" != X ]; then
    exit 0
fi

# Print the end date/time to compare with the start date/time
date

# Report about components that failed for one reason or another
if [ X"$nonexistent_components" != X ]; then
    echo ""
    echo "***** Skipped components (not available) *****"
    echo "Could neither find a git repository (at the <module/component> paths)"
    echo "or a tarball (at the <module/> paths or ./) for:"
    echo "    <module/component>"
    for mod in $nonexistent_components; do
    echo "    $mod"
    done
    echo "You may want to provide the --clone option to wbuild.sh"
    echo "to automatically git-clone the missing components"
    echo ""
fi

if [ X"$failed_components" != X ]; then
    echo ""
    echo "***** Failed components *****"
    for mod in $failed_components; do
    echo "    $mod"
    done
    echo ""
fi

if [ X"$PULL" != X ] && [ X"$pullfailed_components" != X ];  then
    echo ""
    echo "***** Components failed to pull *****"
    for mod in $pullfailed_components; do
    echo "    $mod"
    done
    echo ""
fi

if [ X"$CLONE" != X ] && [ X"$clonefailed_components" != X ];  then
    echo ""
    echo "***** Components failed to clone *****"
    for mod in $clonefailed_components; do
    echo "    $mod"
    done
    echo ""
fi

