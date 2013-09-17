# Jenkins Guide _minimal_

This repository contains the code (config, src and script files) to set up and run a _Cob-Jenkins-CI-Server_ using the _Cob-Pipeline-PlugIn_.

# 1. Prerequisites

## 1.1 Operating System
Install the Operating System of your choice for your Server.

Supported OS:
* _Windows_
* _Debian/Ubuntu_
* _Red Hat/Fedora/CentOS_
* _MacOS X_
* _openSUSE_
* _FreeBSD_
* _OpenBSD_
* _Solaris/OpenIndiana_
* _Gentoo_

Installation Guide for Ubuntu-Server: **[Server Guide](https://github.com/ipa-fmw-ak/Administration/wiki/01.-Ubuntu-Server-IPA-Guide)**

Installation Guide for Ubuntu-Client: **[Client Guide](https://github.com/ipa-fmw-ak/Administration/wiki/02.-Ubuntu-Client---IPA-Guide)**

This Guide proceed for an Ubuntu-Environment...


## 1.2 Java Runtime Environment

### 1.2.1 Check your Java Version:

    java -version

_Output example:_
>
    java version "1.6.0_35"
    Java(TM) SE Runtime Environment (build 1.6.0_35-b10)
    Java HotSpot(TM) Client VM (build 20.10-b01, mixed mode, sharing)

### 1.2.2 Install Java6

    sudo apt-get install openjdk-6-jre
    sudo apt-get install openjdk-6-jdk openjdk-6-source openjdk-6-doc openjdk-6-jre-headless openjdk-6-jre-lib


## 1.3 Git

    sudo apt-get install git-core


## 1.4 Maven

    sudo apt-get install maven


# 2. Jenkins Installation

## 2.1 Preparing a Build Server for Jenkins

_For isolated environment use:_

    sudo adduser jenkins
    sudo groupadd build
    sudo adduser jenkins build


## 2.2 Debian packages "Debian/Ubuntu"

    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
    sudo apt-get update && sudo apt-get install -y jenkins

**[Individual Package Download](http://pkg.jenkins-ci.org/debian/)**

## 2.3 Up and Downgrade
_Upgrade to v1.514_

You can find the **war** file **[here](http://mirrors.jenkins-ci.org/war/)**

    cd /usr/share/jenkins/
    sudo rm -rf jenkins.war
    sudo wget http://mirrors.jenkins-ci.org/war/1.514/jenkins.war
    /etc/init.d/jenkins restart

After a successfull installation you can access the Jenkins-Server in your browser: **[localhost:8080](http://localhost:8080)**

# 3. Jenkins Configuration

## 3.1 Global Security

First off all went to **[Configure Security](http://localhost:8080/configureSecurity/?)**

The **Access Control** section gives the opportunity to select the **Security Realm** which defines how the user's can login.

Check **Jenkins's own user database**.

Now you can decide if every user can sign up or if the admin has to do this.

In the **Authorization** subsection you can define the permission a specific user or a user group gets granted.

Therefore choose the **Project-based Matrix Authorization Strategy**.

Now add an Admin-User and give them all rights!

After click save the Server will throw you to a Login screen. Just register with the user name of the admin you insert in the list.

You have to give permissions to at least the Anonymous and the authenticated user group and an admin user.

Every user will automatically get the permission to see the workspace of all its own jobs.

For the _Pipestarter_ and _Trigger_ job it will also has Build permission.

## 3.2 Manage Jenkins

Under **[Manage Jenkins](http://localhost:8080/configure)** you can configure your Jenkins-Server.

### 3.2.1 Basic

Set the **# of executors** to 1.


# 4. Jenkins-PlugIns Installation

Went to **[Plugin Manager](http://localhost:8080/pluginManager)** and check the wanted PlugIns for installation.

* **[Parameterized Trigger PlugIn](https://wiki.jenkins-ci.org/display/JENKINS/Parameterized+Trigger+Plugin)**

> Is used to transfer build parameters from one job to the next. Here it is used to commit the repository to build or test.

* **[Build Pipeline PlugIn](http://code.google.com/p/build-pipeline-plugin/)**

> Provides a view where all pipeline jobs and their dependencies are shown. It also gives the opportunity to trigger the hardware test jobs manually.

* **[Mailer](https://wiki.jenkins-ci.org/display/JENKINS/Mailer)**

> Generates the email content depending on the build/test results and sends the emails.


_CONFIGURATION_

A template for the Mailer-Plugin is provided in **[this](https://github.com/ipa320/jenkins_setup/blob/master/templates/email-templates/html-with-health-builds-tests.jelly)** repository. Copy it into `/var/lib/jenkins/email-templates`. You can adapt the template to your requirements.

* **[View Job Filters](https://wiki.jenkins-ci.org/display/JENKINS/View+Job+Filters)**

> Provides comprehensive possibilities to filter the jobs that can be seen by the specific user.

* **[Matrix Reloaded PlugIn](https://wiki.jenkins-ci.org/display/JENKINS/Matrix+Reloaded+Plugin)**

> To start one or more entries of a matrix job.

* **[LDAP PlugIn](https://wiki.jenkins-ci.org/display/JENKINS/LDAP+Plugin)**

> Authentication of users is delegated to a LDAP server.

* **[Github OAuth PlugIn](https://wiki.jenkins-ci.org/display/JENKINS/Github+OAuth+Plugin)**

> Authentication of users is delegated to Github using the OAuth protocol.

_More PlugIns will follow..._

For more information visit the **[Jenkins Wiki](https://wiki.jenkins-ci.org/display/JENKINS/Plugins)**


# 5. IPA Configuration

## 5.1 Robotic Operating System

Install **ROS** following **[this](https://github.com/ipa-fmw-ak/Administration/wiki/05.-ROS-Guide)** Guide.

## 5.2 Master

### 5.2.1 Create Cob-Pipeline Configuration Folder

All configurations should be stored in a common folder in the `$HOME` folder called `jenkins-config`.

    mkdir ~/jenkins-config


### 5.2.2 Git Configuration

Set up the GitHub user. This user has to have read-access to all repositories to build and write access to your **jenkins_config** repository.

    git config --global user.name "<USER_NAME>"
    git config --global user.email "<EMAIL>"


### 5.2.3 SSH Configuration


### 5.2.4 jenkins_config Repository

Clone the **jenkins_config** repository into the `jenkins-config` folder.

    git clone git@github.com:ipa320/jenkins_config.git ~/jenkins-config/jenkins_config


### 5.2.5 jenkins_setup Repository

Clone the **jenkins_setup** repository into the `jenkins-config` folder.

    git clone git@github.com:ipa320/jenkins_setup.git ~/jenkins-config/jenkins_setup


### 5.2.6 PYTHONPATH

Add the **jenkins_setup** module to the `$PYTHONPATH`.

    echo "export PYTHONPATH=~/jenkins-config/jenkins_setup/src" > /etc/profile.d/python_path.sh
    echo "source /opt/ros/<ROS_RELEASE>/setup.sh" >> /etc/profile.d/python_path.sh

Afterwards reboot the Jenkins-Server!


### 5.2.7 Tarball Server

The **Tarball-Server** stores all the chroot tarball which will be used during the build process. It can be the Jenkins master or another server. In both cases you have to create a `chroot_tarballs` folder in `$HOME` which contains another folder where the used chroot tarballs will be stored.

    mkdir -p ~/chroot_tarballs/in_use_on__<JENKINS_MASTER_NAME>


## 5.3 Slave

### 5.3.1 Sudo Rights

    sudo visudo -f /etc/sudoers

and add to the file:

    jenkins    ALL=(ALL) NOPASSWD: ALL


### 5.3.2 SSH Access

    ssh-copy-id <master>    # _on slave_
    ssh <master>            # _on slave_
    ssh-copy-id <slave>     # _on master_


### 5.3.3 Pbuilder

    sudo apt-get install pbuilder devscripts

**Performance Improvement**

For configurations a file called **~/.pbuilderrc** in the slaves `$HOME` folder is needed, `/etc/pbuilder/pbuilderrc` is an alternative.

**Pbuilders aptcache**

The aptcach of pbuilder is very useful but when the cache is getting bigger gradually it takes quite a while to open a chroot from the tarball. If you don't want to use it (for instance if you use an external apt-cacher), add the following to `~/.pbuilderrc`:


    # don't use aptcache
    APTCACHE=""

**Use ccache for build**

To use ccache inside the pbuilder add the following to `~/.pbuilderrc`:

    # ccache
    sudo mkdir -p /var/cache/pbuilder/ccache
    sudo chmod a+w /var/cache/pbuilder/ccache
    export CCACHE_DIR="/var/cache/pbuilder/ccache"
    export PATH="/usr/lib/ccache:${PATH}"
    EXTRAPACKAGES=ccache
    BINDMOUNTS="${CCACHE_DIR}"

**Use multi-core zipping**

To speed up the zipping and unzipping of the chroot tarball's, install **pigz**.

    sudo apt-get install pigz

And add the following to `~/.pbuilderrc`:

    # pigz; multicore zipping
    COMPRESSPROG=pigz

**Mount memory to run the pbuilder chroots in it**

Installations and builds inside the chroot need quite a lot write accesses. If you don't have a SSD installed, you can use the memory for this. Therefore you have to create a filesystem in your RAM, using `tmpfs` by adding the following to the slaves `/etc/fstab`:

    # pbuilder
    tmpfs   /var/cache/pbuilder/build   tmpfs   defaults,size=32000M    0   0

The size depends on the size of the chroot you will work with (at least 3G... more is better). It can be larger then the RAM size. If the chroot size exceeds the RAM size it will use the SWAP as well.

Additionally you have to add the following to `~/pbuilderrc`:

    # tmpfs
    APTCACHEHARDLINK=no

Finally mount `tmpfs` by entering (as root):

    mount -a

### 5.3.4 Slave setup on Master
**TODO!!!**


## 5.4 The Cob-Pipeline

For the usage of the **Cob-Pipeline** three parts are necessary:

* **[Cob-Pipeline PlugIn](https://github.com/fmw-jk/cob-pipeline-plugin)**

> This plugin allows the user to configure its individual build/test pipeline via the Jenkins web interface. Afterwards the automatic generation of the pipeline can be triggered.

* **[jenkins_setup repository](https://github.com/ipa320/jenkins_setup)**

> This repository has to be available on the Jenkins-Server. It includes the code for the pipeline generation.

* **[jenkins_config repository](https://github.com/ipa320/jenkins_config)**

> In this repository all the pipeline configurations are stored.

### 5.4.1 Install the Cob-Pipeline

Download the **[.hpi](https://github.com/fmw-jk/cob-pipeline-plugin/releases)** and place it in `/var/jenkins-data/plugins`.

    cd /var/jenkins-data/plugins
    sudo wget https://github.com/fmw-jk/cob-pipeline-plugin/releases/download/v0.9.5-alpha/cob-pipeline.hpi

Restart your Jenkins-Server

    /etc/init.d/jenkins restart

### 5.4.2 Configure the Cob-Pipeline

Go to the **Cob Pipeline Configuration** section. The following fields are all required for the use.

* **Jenkins Admin Login/Password**

> This is the user you configured before in the Configure Security part with all the permissions. Enter its login name and password.
    
* **Configuration Folder**
    
> Enter the path of the Cob-Pipeline configuration folder.
    
* **Tarball Location**
    
> Enter the location where the tarballs are stored.
    
* **GitHub User Login/Password**
    
> This is the user that has read-permission to all the repositories you want to be tested. It has also write-permission to your jenkins-config repository.
    
* **Pipeline Repositories Owner/Fork**
    
> GitHub user that ownes the ^jenkins_setup^ and the ^jenkins_config^ repository.
    
* **ROS Releases**
    
> ROS versions that should be supported by your build/test pipeline.
    
* **Robots**
    
> Nodes which can be chosen for Hardware Build/Test jobs.
    
* **Target Platform URL**
    
> URL where the ROS **targets.yaml** is stored, defining the Ubuntu target platforms for each **ROS** Version, e.g..

_When you fill out the fields, the values will be validated in the background._

## 5.4 Global and Individual Project List Views
**TODO!!!**

## 5.5 Backup your Jenkins-Server
**TODO!!!**
