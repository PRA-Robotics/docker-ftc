FROM base/archlinux:latest
RUN pacman -Sy \
    && pacman -S android-tools \
                 android-udev \
                 git \
                 inotify-tools \
                 jdk8-openjdk \
                 unzip \
                 vim \
                 base-devel --noconfirm \
    && sed -i '/#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf \
    && pacman -Sy \
    && pacman -S lib32-gcc-libs \
                 lib32-glibc \
                 lib32-zlib --noconfirm \
    && useradd -m -G wheel,adbusers ftc \
    && sed -i '/# %wheel ALL=(ALL) NOPASSWD: ALL/s/^# //' /etc/sudoers \
    && echo 'cd /home/ftc/ftc_code' >> /home/ftc/.bashrc \
    && mkdir -p /home/ftc/ftc_code \
    && cd /home/ftc/ftc_code \
    && git init \
    && mkdir teamcode \
    && curl -L https://github.com/ftctechnh/ftc_app/archive/master.zip > ./ftc_app.zip \
    && unzip ./ftc_app.zip \
    && rm ./ftc_app.zip \
    && curl -L https://dl.google.com/android/repository/tools_r25.2.3-linux.zip > ./android_tools.zip \
    && unzip ./android_tools.zip \
    && rm ./android_tools.zip
CMD /bin/bash
