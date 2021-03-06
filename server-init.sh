#!/usr/bin/env bash
# tree

set -v # set verbose

# apt-get update
if ! $updated_recently; then
  sudo apt-get update
  export updated_recently=TRUE
fi

# JDK
if [ ! -z "`which javac`" ]; then
  echo "JDK already installed"
else
  sudo apt-get install default-jdk -y
fi

# Android SDK
if [ ! -z "`which android`" ]; then
  echo "Android SDK already installed"
else
  curl http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz > tmp/android-sdk.tgz
  sudo mkdir /usr/local/bin/android-sdk-linux
  sudo tar xvf tmp/android-sdk.tgz -C /usr/local/bin
  sudo chown -R $USER:$USER /usr/local/bin/android-sdk-linux
  sudo chmod a+x /usr/local/bin/android-sdk-linux/tools/android
  export PATH=$PATH:/usr/local/bin/android-sdk-linux/tools:/usr/local/bin/android-sdk-linux/build-tools
  sudo sh -c "echo \"export PATH=$PATH:/usr/local/bin/android-sdk-linux/tools:/usr/local/bin/android-sdk-linux/build-tools \nexport ANDROID_HOME=/usr/local/bin/android-sdk-linux\" > /etc/profile.d/android-sdk-path.sh"

  # Install Android SDK's tools
  echo "y" | /usr/local/bin/android-sdk-linux/tools/android update sdk -u -a --force -t "android-22,tools,platform-tools,build-tools-23.0.2"

  # required on 64-bit ubuntu
  sudo dpkg --add-architecture i386
  sudo apt-get -qqy update
  sudo apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386
fi


# node
if [ ! -z "`which node`" ]; then
  echo "node already installed"
else
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi


git submodule init
git submodule update

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dir/client
npm install

sudo chown -R $USER ~
