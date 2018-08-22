# akvcam, virtual camera for Linux.
# Copyright (C) 2018  Gonzalo Exequiel Pedone
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

CONFIG += console
CONFIG -= app_bundle qt

TARGET = akvcam
TEMPLATE = lib

lupdate_only {
    HEADERS += \
        src/buffers.h \
        src/controls.h \
        src/device.h \
        src/driver.h \
        src/events.h \
        src/format.h \
        src/ioctl.h \
        src/list.h \
        src/mutex.h \
        src/node.h \
        src/object.h \
        src/utils.h

    SOURCES += \
        src/buffers.c \
        src/controls.c \
        src/device.c \
        src/driver.c \
        src/events.c \
        src/format.c \
        src/ioctl.c \
        src/list.c \
        src/module.c \
        src/mutex.c \
        src/node.c \
        src/object.c \
        src/utils.c
}

KERNEL_RELEASE = $$system(uname -r)
isEmpty(LINUXINCLUDES): LINUXINCLUDES = /usr/lib/modules/$${KERNEL_RELEASE}/build

INCLUDEPATH += \
    $${LINUXINCLUDES}/include \
    $${LINUXINCLUDES}/include/linux \
    $${LINUXINCLUDES}/arch/x86/include

DEFINES += \
    __KERNEL__ \
    KBUILD_MODNAME=\"\\\"\\\"\" \
    CONFIG_PCI \
    CONFIG_HZ=0

OTHER_FILES += \
    src/Makefile

DUMMY_FILES = .
makedriver.input = DUMMY_FILES
makedriver.output = $${PWD}/src/akvcam.ko
makedriver.commands = cd $${PWD}/src; make; cd ..
makedriver.clean = \
    $${PWD}/src/*.ko \
    $${PWD}/src/*.o \
    $${PWD}/src/*.mod.c \
    $${PWD}/src/modules.order \
    $${PWD}/src/Module.symvers
makedriver.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += makedriver
PRE_TARGETDEPS += compiler_makedriver_make_all

# sudo modprobe videodev
# sudo modprobe videobuf2-v4l2
# sudo modprobe videobuf2-vmalloc