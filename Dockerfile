FROM archimg/base-devel:latest
COPY syncDaemon.sh /usr/bin/
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
    && sed -i '/# %wheel ALL=(ALL) NOPASSWD: ALL/s/^# //' /etc/sudoers 
RUN echo 'cd /home/ftc/ftc_code' >> /home/ftc/.bashrc \
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
RUN mkdir /root/.android/ \
    && mkdir /home/ftc/.android/ \
    && echo "count=0" > /root/.android/repositories.cfg \
    && echo "count=0" > /home/ftc/.android/repositories.cfg \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "tools" \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "build-tools;25.0.2" \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "build-tools;23.0.3" \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "platforms;android-25" \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "platforms;android-23" \
    && (while sleep 3; do echo "y"; done) | /home/ftc/ftc_code/tools/bin/sdkmanager "platforms;android-19" \
    && /home/ftc/ftc_code/tools/bin/sdkmanager --update
RUN chown -R ftc:ftc /home/ftc/
COPY compileUpload.sh /home/ftc/ftc_code/
COPY connectADB.sh /home/ftc/ftc_code/
CMD /bin/bash
USER ftc
