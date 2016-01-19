# tree

# apt-get update
if ! $updated_recently; then
  sudo apt-get update
  export updated_recently=TRUE
fi

# JDK
which_javac=`which javac`
if [ ! -z "$which_javac" ]; then
  echo "JDK already installed"
else
  sudo apt-get install default-jdk -y
fi

# Android SDK
which_android=`which android`
if [ ! -z "$which_android" ]; then
  echo "Android SDK already installed"
else
  curl http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz > android-sdk.tgz
  tar xvf android-sdk.tgz
  sudo mv android-sdk-linux /usr/local/bin
  sudo chown -R root:root /usr/local/bin/android-sdk-linux/
  sudo chmod a+x /usr/local/bin/android-sdk-linux/tools/android
  export PATH=$PATH:/usr/local/bin/android-sdk-linux/tools:/usr/local/bin/android-sdk-linux/build-tools
  sudo sh -c "echo \"export PATH=$PATH:/usr/local/bin/android-sdk-linux/tools:/usr/local/bin/android-sdk-linux/build-tools\" > /etc/profile.d/android-sdk-path.sh"

  # Install Android SDK's tools
  /usr/local/bin/android-sdk-linux/tools/android list sdk --all
  echo "################ Android SDK Install ########################"
  echo "Please select which following packages you wish to install."
  echo "You want the numbers for the following"
  echo "  * Android SDK Tools"
  echo "  * Android SDK Platform Tools"
  echo "  * Android SDK Build Tools"
  echo "  * Android SDK Platform (whatever version you need)"
  echo "For example: 1,2,6,26"
  echo "Install the proper versions please. Example: 1,2,6,26"
  echo -n "Package numbers separated by comma, no spaces:"
  read packages
  /usr/local/bin/android-sdk-linux/tools/android update sdk -u -a -t $packages

fi


# node
which_node=`which node`
if [ ! -z "$which_node" ]; then
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

chown -R `whoami` .
