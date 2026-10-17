#!/bin/sh
# Supported native targets: Apple Silicon macOS and Linux (including Ubuntu WSL2).
# No configure-generated files are needed. Dependencies are installed separately.
set -eu
cd "$(dirname "$0")"
case "$(uname -s)" in
    Darwin)
        if command -v brew >/dev/null 2>&1; then
            if NCURSES_PREFIX=$(brew --prefix ncurses 2>/dev/null); then
                export PKG_CONFIG_PATH="$NCURSES_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
            fi
        fi
        ;;
    Linux) ;;
    *) echo "Use macOS or Linux / WSL2 to build this ncurses application." >&2; exit 1 ;;
esac
if ! command -v pkg-config >/dev/null 2>&1; then
    echo "Missing pkg-config; see README.md for platform dependencies." >&2
    exit 1
fi
if ! pkg-config --exists ncursesw; then
    echo "Missing wide-character ncurses development files; see README.md." >&2
    exit 1
fi
NCURSES_FLAGS=$(pkg-config --cflags --libs ncursesw)
# CFLAGS / LDFLAGS and pkg-config output intentionally expand as compiler arguments.
${CC:-cc} ${CFLAGS:--O2} -std=gnu11 -D_XOPEN_SOURCE_EXTENDED=1 \
    -DEXCLUDE_CONFIG_H '-DVERSION="2.0-gm"' \
    -DHAVE_NCURSES_H -DHAVE_SYS_IOCTL_H -DHAVE_UNISTD_H -DHAVE_TERMIOS_H \
    -DHAVE_RESIZETERM -DHAVE_WRESIZE -DHAVE_USE_DEFAULT_COLORS \
    -o cmatrix cmatrix.c unimatrix.c $NCURSES_FLAGS ${LDFLAGS:-}
# Both dedicated wrappers share this executable; cmatrix retains its original mode.
cp cmatrix cmatrix-uni-native
printf '%s\n' 'Built cmatrix, cmatrix-uni-native; run ./cmatrix-gm --help.'
