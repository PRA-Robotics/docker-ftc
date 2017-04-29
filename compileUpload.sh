#!/bin/bash

PWD=/home/ftc/ftc_code

export ANDROID_HOME=$PWD

rsync -avz $PWD/teamcode/ $PWD/ftc_app-master/TeamCode/src/main/java/org/firstinspires/ftc/teamcode --delete

cd ftc_app-master

./gradlew installDebug

cd $PWD
